module Commands
  class ArchiveConfigCommand
    class << self
      def name
        :archive_config
      end

      def attributes
        {
            min_args: 1,
            max_args: 1,
            usage: "archive_config #channel",
            description: "Set the channel to post archived pins",
            permission_level: 1
        }
      end

      def command(event, channel)
        return if event.from_bot?

        archive_config = ArchiveConfig.find_or_create_by(server: event.server.id)
        archive_config.update(channel: channel.match(/<#(\d+)>/)[1])
        "Archive configured"
      end
    end
  end
end