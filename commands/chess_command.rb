module Commands
  class ChessCommand
    class << self

      def name
        :chess
      end

      def attributes
        {
            usage: "bible",
            description: "Start a game of chess"
        }
      end

      def command(event)
        return if event.from_bot?
        event << "This is where I would put the URL"

        event << "IF I HAD ONE >:("
      end
    end
  end
end