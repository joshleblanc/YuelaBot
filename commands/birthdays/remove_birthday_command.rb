module Commands
  class RemoveBirthdayCommand
    class << self
      def name
        :remove_bday
      end

      def attributes
        {
            min_args: 1,
            max_args: 1,
            description: "Remove a user's birthday",
            usage: '[rbd][remove_birthday] [@user]',
            arg_types: [Discordrb::User],
            permission_level: 1,
            aliases: [:rbd]
        }
      end

      def command(e, user)
        return if e.from_bot?
        begin
          user = User.find(user.id)
          birthday = user.birthdays.find_by(server: e.server.id)
          if birthday
            birthday.destroy
            "#{user.name}'s birthday has been forgotten"
          else
            "User does not have a birthday registered"
          end
        rescue StandardError => e
          e.message
        end
      end
    end
  end
end