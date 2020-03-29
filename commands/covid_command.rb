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
        stdout, stderr, status = Open3.capture3("kovid", *args)
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
