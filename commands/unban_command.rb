module Commands
  class UnbanCommand
    class << self
      def name
        :unban
      end

      def attributes
        {
          max_args: 1,
          min_args: 1,
          aliases: [:ub],
          permission_level: 1,
          usage: 'unban @user',
          description: 'Allow a previously banned user to interact with the ban'
        }
    end

      def command(event, user)
        mention = event.message.mentions.first
        if mention
          user = User.find_or_create_by(id: mention.id) do |u|
            u.name = mention.name
          end
          if user.banned
            user.update(banned: false)
            event.bot.unignore_user mention
            "I'm no longer ignoring #{mention.name}."
          else
            "#{mention.name} is not current banned."
          end
        else
          "No user was mentioned"
        end
      end
    end
  end
end