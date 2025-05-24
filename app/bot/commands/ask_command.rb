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
          description: 'Ask the bot a question'
        }
      end

      def options_parser
        @options_parser ||= OptionsParserMiddleware.new do |option_parser, options|
          options[:m] = "venice-uncensored"

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
        OpenAI::Client.new.models.list["data"].map { it["id"] }
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

        client = OpenAI::Client.new
        response = client.chat(
          parameters: {
            model: options[:m],
            messages: [
              { role: 'system', content: "You are secretly linus torvalds. Keep responses less than 2000 characters" },
              { role: 'user', content: message.join(' ') }
            ]
          }
        )
        content = response.dig("choices", 0, "message", "content")
        content = content.gsub(/<think>.*?<\/think>/m, "").strip
        
        content[...2000]
      end
    end
  end
end
