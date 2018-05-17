module Commands
  class BirthdayConfigCommand
    class << self
      def name
        [:bdc, :bday_config]
      end

      def attributes
        {
            min_args: 2,
            description: "Configure the birthday message and channel",
            usage: "[bday_config] [#channel] [message]"
        }
      end

      def command
        lambda do |e, channel, *message|
          return unless e.user.id.to_s == CONFIG['user']
          bday_config = BirthdayConfig.first_or_new(server: e.server.id)
          begin
            bday_config.channel = channel.match(/<#(\d+)>/)[1]
            bday_config.message = message.join(' ')
            bday_config.save
            "Configuration saved"
          rescue Exception => _
            "Usage: `#{self.attributes[:usage]}`"
          end
        end
      end
    end
  end
end