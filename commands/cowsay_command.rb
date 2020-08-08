module Commands
  class CowsayCommand
    class << self
      include Cowsay

      def name
        :cowsay
      end

      def attributes
        {
          description: "cowsay",
          usage: "cowsay",
          aliases: []
        }
      end

      def command(event, *args)
        return if event.from_bot?

        output = "```"
        output << Cowsay.say(args.join(" "), "cow")
        output << "```"
        output
      end
    end
  end
end
