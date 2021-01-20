module Commands
  module Birthdays
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
          return if e.from_bot?
          begin
            BirthdayConfig.find_or_create_by(server: e.server.id) do |bc|
              bc.channel = channel.match(/<#(\d+)>/)[1]
              bc.message = message.join(' ')
            end
            "Configuration saved"
          rescue StandardError => e
            e.message
          end
        end
      end
    end
  end
end