module Commands
  class SpreadCommand
    class << self
      def name
        :spread
      end

      def attributes
        {
          description: "Spread your words",
          usage: "spread <phrase>",
          aliases: [:sp]
        }
      end

      def command(event, *args)
        return if event.from_bot?

        args.join(' ').split.join(' ')
      end
    end
  end
end
