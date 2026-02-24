require 'json'

require_relative '../minimax_client'

include Routines::ArchiveRoutine
include Routines::BirthdayRoutine
include Middleware
include Helpers::InjectMiddleware

unless ENV['DISCORD']
    abort "You're missing your discord API token! put discord=<your token here> in a .env file"
end

GLOBAL_MIDDLEWARE = [
  CheckAboveMiddleware,
  SelfPromotionMiddleware,
  TypingMiddleware
]

User.where(banned: true).each do |user|
  BOT.ignore_user user.id
end

if ENV['ADMINS']
    ENV['ADMINS'].split(',').each do |admin|
        BOT.set_user_permission(admin.to_i, 1)
    end
end

Afk.destroy_all
UserCommand.all.each do |command|
  BOT.command(command.name.to_sym, &command.method(:run))
end

BOT.command(:ping) do |event|
  event.respond "pong"
end

def register_ask_application_command
  client_id = ENV['DISCORD_CLIENT_ID']
  return if client_id.blank?

  token = ENV['DISCORD']
  return if token.blank?

  auth_token = token.start_with?('Bot ') ? token : "Bot #{token}"
  description = 'Ask the bot a question'

  builder = Discordrb::Interactions::OptionBuilder.new
  builder.string('query', 'Your question', required: true)

  options = builder.to_a
  guild_id = ENV['DISCORD_SLASH_COMMAND_GUILD_ID']

  existing = if guild_id.present?
               JSON.parse(Discordrb::API::Application.get_guild_commands(auth_token, client_id, guild_id)).find { |c| c['name'] == 'ask' }
             else
               JSON.parse(Discordrb::API::Application.get_global_commands(auth_token, client_id)).find { |c| c['name'] == 'ask' }
             end

  if existing
    if guild_id.present?
      Discordrb::API::Application.edit_guild_command(auth_token, client_id, guild_id, existing['id'], 'ask', description, options, nil, 1, nil, [0,1,2])
    else
      Discordrb::API::Application.edit_global_command(auth_token, client_id, existing['id'], 'ask', description, options, nil, 1, nil, [0,1,2])
    end
  else
    if guild_id.present?
      Discordrb::API::Application.create_guild_command(auth_token, client_id, guild_id, 'ask', description, options, nil, 1, nil, [0,1,2])
    else
      Discordrb::API::Application.create_global_command(auth_token, client_id, 'ask', description, options, nil, 1, nil, [0,1,2])
    end
  end
rescue => e
  Rails.logger.error "Failed to register /ask application command: #{e.message}"
end

register_ask_application_command

def register_imagine_application_command
  client_id = ENV['DISCORD_CLIENT_ID']
  return if client_id.blank?

  token = ENV['DISCORD']
  return if token.blank?

  auth_token = token.start_with?('Bot ') ? token : "Bot #{token}"
  description = 'Generate an image'

  builder = Discordrb::Interactions::OptionBuilder.new
  builder.string('prompt', 'What to generate', required: true)

  options = builder.to_a
  guild_id = ENV['DISCORD_SLASH_COMMAND_GUILD_ID']

  existing = if guild_id.present?
               JSON.parse(Discordrb::API::Application.get_guild_commands(auth_token, client_id, guild_id)).find { |c| c['name'] == 'imagine' }
             else
               JSON.parse(Discordrb::API::Application.get_global_commands(auth_token, client_id)).find { |c| c['name'] == 'imagine' }
             end

  if existing
    if guild_id.present?
      Discordrb::API::Application.edit_guild_command(auth_token, client_id, guild_id, existing['id'], 'imagine', description, options, nil, 1, nil, [0,1,2])
    else
      Discordrb::API::Application.edit_global_command(auth_token, client_id, existing['id'], 'imagine', description, options, nil, 1, nil, [0,1,2])
    end
  else
    if guild_id.present?
      Discordrb::API::Application.create_guild_command(auth_token, client_id, guild_id, 'imagine', description, options, nil, 1, nil, [0,1,2])
    else
      Discordrb::API::Application.create_global_command(auth_token, client_id, 'imagine', description, options, nil, 1, nil, [0,1,2])
    end
  end
rescue => e
  Rails.logger.error "Failed to register /imagine application command: #{e.message}"
end

register_imagine_application_command

def ask_venice(event, query)
  return if event.respond_to?(:from_bot?) && event.from_bot?
  return if event.user.id.to_s == "152107946942136320"

  channel_id = event.respond_to?(:channel_id) ? event.channel_id : event.channel.id
  server_external_id = if event.respond_to?(:server_id)
                         event.server_id
                       else
                         event.respond_to?(:server) ? event.server&.id : nil
                       end


  event.channel.start_typing unless event.respond_to?(:interaction) # just a hack to not do the typing thing for slash commands

  author = event.user

  begin
    # Ensure user exists
    user = User.find_or_create_by(id: author.id) do
      _1.name = author.name
    end

    server = nil
    if server_external_id.present?
      server = Server.find_or_create_by(external_id: server_external_id) do |s|
        s.name = event.respond_to?(:server) ? event.server.name : "Unknown"
      end
    end

    # Initialize conversation service
    conversation = BotConversationService.new(
      channel_id: channel_id,
      server_id: server&.id,
      user_id: user.id,
      bot_user: BOT.profile
    )


    # Preserve original content with mentions for storage
    original_content = query

    # Clean the message content (remove bot mention) for processing
    content = query.gsub(/<@!?#{BOT.profile.id}>/, '').strip

    # Check if this is a reply and include reply context
    if event.respond_to?(:message) && event.message.reply?
      referenced_msg = event.message.referenced_message
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
        content = "#{reply_context} #{content}".strip
        # Also add reply context to original content for storage
        original_content = "#{reply_context} #{original_content}".strip
      end
    end

    # Resolve user mentions to usernames for better context
    if event.respond_to?(:message) && event.message.mentions.any?
      event.message.mentions.each do |mentioned_user|
        # Replace mention with username for better readability
        username = mentioned_user.display_name || mentioned_user.username
        mention_pattern = /<@!?#{mentioned_user.id}>/
        content = content.gsub(mention_pattern, "@#{username}")
        original_content = original_content.gsub(mention_pattern, "@#{username}")
      end
    end

    # If no content after removing mention, use a default prompt
    content = "Hello!" if content.empty?

    # Add user message to history (preserve original with mentions)
    conversation.add_user_message(
      content: original_content,
      message_id: event.respond_to?(:message) ? event.message.id : event.interaction.id
    )

    # Build conversation history
    messages = conversation.build_conversation_history

    # Call MiniMax API if available, otherwise fall back to Venice
    if ENV['MINIMAX_API_KEY'].present?
      # MiniMax Anthropic-compatible API only supports 'user' and 'assistant' roles
      # Filter out system messages (system prompt is passed separately)
      filtered_messages = messages.reject { |msg| msg[:role] == 'system' }

      # Convert conversation history to MiniMax format
      minimax_messages = filtered_messages.map do |msg|
        { role: msg[:role], content: [{ type: 'text', text: msg[:content] }] }
      end

      bot_response = MinimaxClient.chat(
        messages: minimax_messages,
        system: conversation.build_system_prompt
      )
      full_response = bot_response
    else
      # Call Venice API
      client = VeniceClient::ChatApi.new
      response = client.create_chat_completion(
        chat_completion_request: {
          model: TEXT_MODEL,
          messages: messages,
          venice_parameters: {
            strip_thinking_response: true,
            enable_web_scraping: true,
            enable_web_search: "auto",
          }
        }
      )

      # Extract and clean response
      bot_response = response.choices.first.message.content
      bot_response = bot_response.gsub(/<think>.*?<\/think>/m, "").strip

      # Store the full response for conversation history
      full_response = bot_response
    end

    # Slash commands don't support reactions for pagination, so handle separately
    if !event.respond_to?(:message)
      # Slash command: send as single message (with truncation if needed)
      prefix = "> #{query}\n"
      max_response_length = 2000 - prefix.length

      if bot_response.length > max_response_length
        truncated_response = bot_response[...max_response_length] + "... (truncated for Discord length limits)"
        event.edit_response(content: "#{prefix}#{truncated_response}")
      else
        event.edit_response(content: "#{prefix}#{bot_response}")
      end
    elsif bot_response.length > 2000
      # Regular message: use pagination container
      pagination = TextPaginationContainer.new(bot_response, event)
      pagination.send_paginated
    else
      event.message.reply(bot_response)
    end

    # Add assistant response to history (use full response), but only if not blank
    if full_response.present?
      conversation.add_assistant_message(
        content: full_response,
        message_id: nil
      )
    end

  rescue => e
    # Fallback to canned response on error
    p "Bot mention error: #{e.message}, #{e.backtrace}"
    crg = CannedResponseGenerator.new
    if event.respond_to?(:message)
      event.message.reply(crg.generate(event.author.mention))
    else
      event.edit_response(content: crg.generate(event.user.mention))
    end
  end
end

BOT.application_command(:ask) do |event|
  event.defer(ephemeral: false)
  ask_venice(event, event.options['query'])
end

BOT.application_command(:imagine) do |event|
  prompt = event.options['prompt']
  event.defer(ephemeral: false)

  begin
    Commands::ImagineCommand.command(event, { m: 'grok-imagine' }, prompt)
    event.edit_response(content: "> #{prompt}")
  rescue => e
    event.edit_response(content: "Error generating image: #{e.message}")
  end
end

def find_commands(mod)
  mod.constants.map do |c|
    command = mod.const_get(c)
    case command
    when Class
      command
    when Module
      find_commands(command)
    else
      nil
    end
  end
end

find_commands(Commands).flatten.compact.each do |command|
  BOT.command(command.name, command.attributes, &inject_middleware(command))
end

Reactions.constants.map do |r|
  reaction = Reactions.const_get(r)
  reaction.is_a?(Class) ? reaction : nil
end.compact.each do |reaction|
  BOT.message(reaction.attributes, &reaction.method(:command))
end

BOT.message_edit(&method(:archive_routine))

typing = {}
last_typing_message = {}
BOT.typing do |event|
  now = Time.now
  typing[event.channel.id] ||= {}
  typing[event.channel.id][event.user.id] = event.timestamp

  typing[event.channel.id].reject! do |k, v|
    now - v > 5
  end
  last_typing_event = last_typing_message[event.channel.id]
  if typing[event.channel.id].count > 3
    if last_typing_event.nil? || now - last_typing_event > 60
      event.respond "https://cdn.discordapp.com/attachments/550684271220752406/552906458421919771/unknown.png"
      last_typing_message[event.channel.id] = event.timestamp
      typing[event.channel.id] = {}
    end
  end
end

BOT.message do |event|
  next if event.from_bot?
  next unless event.server.present?

  author_id = event.author.id
  user = User.find_or_create_by(id: author_id)

  urs = UserReaction.joins(:servers).where(servers: { external_id: event.server.id }).select do |ur|
    Regexp.new(ur.regex).match(event.message.content)
  end
  urs.each do |ur|
    if rand <= ur.chance
      ur.trigger event
    end
  end

  user_ids = event.message.mentions.map(&:id)
  user_ids.each do |uid|
    user = User.find_by(id: uid)
    if user&.afk
      out = ''
      out << "#{user.name} is afk"
      out << ": #{user.afk.message}" if user.afk.message
      event << out
    end
  end
end

BOT.mention do |event|
  ask_venice(event, event.message.content)
end

scheduler = Rufus::Scheduler.new
scheduler.every '1d', first: :now do
  birthday_routine(BOT)
  LaunchManager.instance.schedule
end

scheduler.every '1m' do
  TwitchStream.all.each(&:renew)

  TwitchStreamEvent.all.each do |event|
    twitch_configs = TwitchConfig.where(server: event.server)
    event.data.each do |datum|
      user = Apis::Twitch.user(login: datum["user_name"])
      embed = Discordrb::Webhooks::Embed.new
      case datum["type"]
      when "live"
        embed.title = "#{datum["user_name"]} is now live on Twitch!"
        embed.url = "https://twitch.tv/#{datum["user_name"]}"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: datum["thumbnail_url"])
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: datum["user_name"], url: user["profile_image_url"])
        twitch_configs.each do |config|
          BOT.send_message(config.channel, nil, nil, embed)
        end
      end
    end
    event.destroy
  end
end
