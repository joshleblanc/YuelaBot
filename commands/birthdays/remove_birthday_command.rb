module Commands
  class RemoveBirthdayCommand
    class << self
      def name
        [:rbd, :remove_bday]
      end

      def attributes
        {
            min_args: 1,
            max_args: 1,
            description: "Remove a user's birthday",
            usage: '[rbd][remove_birthday] [@user]',
            arg_types: [Discordrb::User],
            permission_level: 1
        }
      end

      def command
        lambda do |e, user|
          begin
            user = User.get(user.id)
            birthday = user && user.birthdays.first(server: e.server.id)
            if user && birthday
              birthday.destroy
              "#{user.name}'s birthday has been forgotten"
            else
              "User does not have a birthday registered"
            end
          rescue
            "Can't do anything with that"
          end
        end
      end
    end
  end
end