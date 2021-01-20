module Commands
  class PurgeCommand
    class << self
      def name
        :purge
      end

      def attributes
        {
          description: "Delete up to 100 messages from a user",
          usage: "purge @user",
          min_args: 1,
          max_args: 1,
          aliases: [:p],
          permission_level: 1
        }
      end

      def command(event, _)
        return if event.from_bot?
        user = event.message.mentions[0]
        if user
          num_deleted = event.channel.prune(100) do |message|
            message.author.id == user.id
          end
          "Deleted #{num_deleted} messages by #{user.name}"
        else
          "No user mentioned. Cannot delete messages"
        end
      end
    end
  end
end