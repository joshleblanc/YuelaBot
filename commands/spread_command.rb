module Commands
  class SpreadCommand
    class << self
      def name
        :spread
      end

      def options_parser
        @options_parser ||= OptionsParserMiddleware.new do |option_parser, options|
          options[:s] = " "
          options[:a] = 1

          option_parser.banner = "Usage: spread [options] text"

          option_parser.on("-s", "--separator SEPARATOR", "Specify the character to spread with") do |s|
            options[:s] = s
          end

          option_parser.on("-a", "--amount AMOUNT", Integer, "Specify how much to spread the message") do |a|
            options[:a] = a
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

        input.join(' ').chars.join(options[:s] * options[:a])
      end
    end
  end
end
