module Commands
  class BirthdayConfigCommand
    class << self
      def name
        :bday_config
      end

      def attributes
        {
            min_args: 2,
            description: 'Configure the birthday message and channel',
            usage: '[bday_config] [#channel] [message]',
            arg_types: [String, String],
            permission_level: 1,
            aliases: [:bdc]
        }
      end

      def command(e, channel, *message)
        begin
          bday_config = BirthdayConfig.first_or_new(server: e.server.id)
          bday_config.channel = channel.match(/<#(\d+)>/)[1]
          bday_config.message = message.join(' ')
          bday_config.save
          "Configuration saved"
        rescue
          "Nope, not quite right"
        end
      end
    end
  end
end