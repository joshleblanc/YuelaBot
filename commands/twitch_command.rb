module Commands
  class TwitchCommand
    class << self
      def name
        :twitch
      end

      def options_parser
        @options_parser ||= OptionsParserMiddleware.new do |option_parser, options|
          option_parser.on("-c", "--config CHANNEL", "Specify the server to post streams in") do |channel|
            options[:channel] = channel
          end

          option_parser.on("-a", "--add NAME", "Add a stream to watch") do |name|
            options[:name] = name
          end

          option_parser.banner = "Usage: twitch [options]"
        end
      end

      def middleware
        [
          options_parser
        ]
      end

      def attributes
        {
          description: <<~USAGE,
            Twitch stream watcher
            #{options_parser.usage}
          USAGE
          aliases: []
        }
      end


      def command(event, *args)
        return if event.from_bot?

        options, *input = args

        if options[:channel]
          channel = options[:channel].match(/<#(\d+)>/)[1]
          if channel
            config = TwitchConfig.where(server: event.server.id).first_or_create
            config.update(channel: options[:channel])
            event << "Twitch config updated"
          end
        end

        if options[:name] 
          user = Apis::Twitch.user(options[:name])
          lease_expires = Apis::Twitch.subscribe(user["id"], event.server.id)
          TwitchStream.where(server: event.server.id, twitch_login: options[:name], expires_at: Time.now + lease_expires).first_or_create
          event << "Twitch stream added"
        end
      end
    end
  end
end
