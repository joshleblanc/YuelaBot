module Commands
  class AddBirthdayCommand
    class << self
      def name
        [:add_bday, :abd]
      end

      def attributes
        {
          min_args: 3,
          max_args: 3,
          description: "Add a birthday for a user",
          usage: "[add_bday][abd] [@user] [month (Number)] [day (Number)]",
          arg_types: [Discordrb::User, Integer, Integer]
        }
      end

      def command
        lambda do |event, user, month, day|
          begin
            user_id = user.id
            mention = event.message.mentions.first
            if mention.id != user_id.to_i
              event << "User must be mentioned"
            end

            user = User.get(user_id)
            if Birthday.first(user: user, server: event.server.id)
              "A birthday already exists for that user"
            else
              user = User.first_or_new(id: mention.id)
              user.name = mention.name
              Birthday.create(
                user: user,
                month: Integer(month),
                day: Integer(day),
                server: event.server.id
              )
            end
          rescue
            "That's not going to work"
          end
        end
      end
    end
  end
end