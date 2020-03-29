module Commands
  class CovidCommand
    class << self
      def name
        :covid
      end

      def attributes
        {
          description: "A proxy to the kovid command line utility. https://github.com/siaw23/kovid",
          usage: "covid --help",
          aliases: [:kovid]
        }
      end

      def command(event, *args)
        return if event.from_bot?
        event.channel.start_typing
        match = args.join(" ").match(/^([\w\s]+)/)[0]
        return "Only alphanumeric input, please" unless match
        command = match[0]
        stdout, stderr, status = Open3.capture3("kovid #{command}")
        if status.success?
          <<~OUTPUT
            ```
            #{stdout}
            ```
          OUTPUT
        else
          event.respond <<~OUTPUT
            ```
            #{stderr}
            ```
          OUTPUT
        end
      end
    end
  end
end
