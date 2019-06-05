module Commands
  class BanCommand
    class << self
      def name
        :ban
      end

      def attributes
        {
          max_args: 1,
          min_args: 1,
          aliases: [:b],
          permission_level: 1,
          usage: 'ban @user',
          description: 'Prevents a user from being able to invoke the bot'
        }
      end

      def command(event, user)
        mention = event.message.mentions.first
        if mention
          user = User.find_or_create_by(id: mention.id) do |u|
            u.name = mention.name
          end
          if user.banned
            "User is already being ignored"
          else
            user.update(banned: true)
            event.bot.ignore_user mention
            "I'm now ignoring #{mention.name}."
          end
        else
          "No user was mentioned"
        end
      end
    end
  end
end