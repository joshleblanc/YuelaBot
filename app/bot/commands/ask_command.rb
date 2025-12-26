module Commands
  class AskCommand
    class << self
      def name
        :ask
      end

      def attributes
        {
          min_args: 1,
          usage: 'ask query',
          description: <<~USAGE,
            Ask the bot a question
            #{options_parser.usage}
          USAGE
          aliases: []
        }
      end

      def options_parser
        @options_parser ||= OptionsParserMiddleware.new do |option_parser, options|
          options[:m] = "zai-org-glm-4.7"

          option_parser.banner = "Usage: ask [options] query"

          option_parser.on("-m", "--model MODEL", "Specify a \"model\"") do |model|
            options[:m] = model
          end

          option_parser.on("-r", "--random", "Use a random  \"model\"") do
            options[:r] = true
          end

          option_parser.on("-l", "--list", "List available \"models\"") do
            options[:l] = true
          end
        end
      end

      def middleware
        [
          options_parser
        ]
      end

      def models 
        @models ||= VeniceClient::ModelsApi.new.list_models(type: "text").data.map { it[:id] }
      end

      def command(e, *args)
        return if e.from_bot?
        return if e.user.id.to_s == "152107946942136320"

        options, *message = args

        if options[:l]
          output = "```\n"
          output << models.join("\n") 
          output << "```"
          return output
        end

        if options[:r]
          options[:m] = models.sample
        end

        # Prepare the final message content with reply context if applicable
        final_message = message.join(' ')
        
        # Preserve original message content with mentions for storage
        original_message_content = e.message.content
        # Extract just the ask command part (remove command prefix)
        command_prefix_pattern = /^[!.]ask\s*/i
        original_ask_content = original_message_content.gsub(command_prefix_pattern, '').strip
        
        if e.message.reply?
          referenced_msg = e.message.referenced_message
          if referenced_msg
            reply_content = referenced_msg.content

            # Truncate long messages for context
            reply_content = reply_content[...500] + "..." if reply_content.length > 500

            # Build context string - distinguish between bot and user messages
            if referenced_msg.author.id == BOT.profile.id
              # User is replying to the bot's own message
              reply_context = "[User is replying to your previous message: \"#{reply_content}\"]"
            else
              # User is replying to another user's message
              reply_author = referenced_msg.author.display_name || referenced_msg.author.username
              reply_context = "[Replying to #{reply_author}: \"#{reply_content}\"]"
            end

            # Prepend reply context to user's message
            final_message = "#{reply_context} #{final_message}".strip
            original_ask_content = "#{reply_context} #{original_ask_content}".strip
          end
        end

        # Resolve user mentions to usernames for better context
        if e.message.mentions.any?
          e.message.mentions.each do |mentioned_user|
            # Replace mention with username for better readability
            username = mentioned_user.display_name || mentioned_user.username
            mention_pattern = /<@!?#{mentioned_user.id}>/
            final_message = final_message.gsub(mention_pattern, "@#{username}")
            original_ask_content = original_ask_content.gsub(mention_pattern, "@#{username}")
          end
        end

        # Track message history if server is present
        if e.server.present?
          begin
            user = User.find_or_create_by(id: e.author.id)
            server = Server.find_or_create_by(external_id: e.server.id) do |s|
              s.name = e.server.name
            end

            conversation = BotConversationService.new(
              server_id: server.id,
              user_id: user.id,
              bot_user: BOT.profile
            )
            
            conversation.add_user_message(
              content: original_ask_content,
              message_id: e.message.id
            )
          rescue => error
            Rails.logger.error "Failed to track ask command message: #{error.message}"
          end
        end

        client = VeniceClient::ChatApi.new
        response = client.create_chat_completion(
          body: {
            model: options[:m],
            messages: [
              { role: 'system', content: "You are secretly linus torvalds. Keep responses less than 2000 characters" },
              { role: 'user', content: final_message }
            ]
          }
        )
        content = response.choices.first[:message][:content]
        content = content.gsub(/<think>.*?<\/think>/m, "").strip
        
        # Track assistant response
        if e.server.present? && defined?(conversation)
          begin
            conversation.add_assistant_message(content: content)
          rescue => error
            Rails.logger.error "Failed to track ask command response: #{error.message}"
          end
        end
        
        # Use pagination for long responses
        if content.length > 2000
          pagination = TextPaginationContainer.new(content, e)
          pagination.send_paginated
          nil # Return nil to prevent double-sending
        else
          content
        end
      end
    end
  end
end
