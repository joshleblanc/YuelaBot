module Commands
  class SpreadCommand
    class << self
      def name
        :spread
      end

      def options_parser
        @options_parser ||= OptionsParserMiddleware.new do |option_parser, options|
          options[:s] = " "

          option_parser.banner = "Usage: spread [options] text"

          option_parser.on("-s", "--separator SEPARATOR", "Specify the character to spread with") do |s|
            options[:s] = s
          end
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
          Dramatically spread your message
          #{options_parser.usage}
          USAGE
          aliases: [:sp]
        }
      end

      def command(event, *args)
        return if event.from_bot?

        options, *input = args

        input.join(' ').chars.join(options[:s])
      end
    end
  end
end
