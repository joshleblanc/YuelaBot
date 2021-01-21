module Commands
  class PrefixCommand
    class << self
      def name
        :prefix
      end

      def attributes
        {
          min_args: 1,
          usage: 'prefix [new prefix]',
          description: 'Sets the prefix for the server',
          permission_level: 1
        }
      end

      def command(e, *message)
        return if e.from_bot?

        prefix = ServerPrefix.where(server: e.server.id).first_or_initialize
        prefix.prefix = message[0]
        prefix.save

        "Prefix set to #{message[0]}"
      end
    end
  end
end
