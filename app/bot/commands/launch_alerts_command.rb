module Commands
  class LaunchAlertsCommand
    class << self
      def name
        :launch_alerts
      end

      def attributes
        {
          description: "Register that you want to receive alerts for upcoming rocket launches",
          usage: "launch_alerts",
          aliases: [:la]
        }
      end

      def command(event, *args)
        return if event.from_bot?

        # create config and channel if this is the first user registering
        config = LaunchAlertConfig.find_or_create_by(server_id: event.server.id)

        # re-create the channel if someone has deleted it
        unless event.server.channels.map { |c| c.id.to_s }.include? config.channel_id
          channel = event.server.create_channel("Launch Alerts", 0)
          config.update(channel_id: channel.id)
        end

        user = User.find_or_create_by(id: event.author.id) do |user|
          user.name = event.author.name
        end

        if user.launch_alert_configs.exists?(config.id)
          user.launch_alert_configs.destroy(config)
          "You're all set #{event.author.mention}. You won't receive notifications for launches in the future"
        else
          user.launch_alert_configs << config
          user.save
          "Thanks #{event.author.mention}, you're all signed up"
        end
      end
    end
  end
end
