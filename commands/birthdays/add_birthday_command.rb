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
          usage: "[add_bday][abd] [@user] [month (Number)] [day (Number)]"
        }
      end

      def command(event, user, month, day)
        begin
          mention = event.message.mentions.first

          user = User.get(mention.id)
          if Birthday.first(user: user, server: event.server.id)
            "A birthday already exists for that user"
          else
            user = User.first_or_new(id: mention.id)
            user.name = mention.name
            Birthday.create(
              user: user,
              month: month.to_i,
              day: day.to_i,
              server: event.server.id
            )
          end
        rescue StandardError => e
          "That's not going to work"
        end
      end
    end
  end
end