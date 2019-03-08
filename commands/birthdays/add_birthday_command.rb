module Commands
  class AddBirthdayCommand
    class << self
      def name
        :add_bday
      end

      def attributes
        {
            min_args: 3,
            max_args: 3,
            description: "Add a birthday for a user",
            usage: "[add_bday][abd] [@user] [month (Number)] [day (Number)]",
            aliases: [:abd]
        }
      end

      def command(event, user, month, day)
        return if event.from_bot?
        begin
          mention = event.message.mentions.first

          if Birthday.find_by(user_id: mention.id, server: event.server.id)
            "A birthday already exists for that user"
          else
            User.find_or_create_by(id: mention.id) do |u|
              u.name = mention.name
              u.birthdays << Birthday.new(
                  month: month.to_i,
                  day: day.to_i,
                  server: event.server.id
              )
            end
            "Saved #{mention.name}'s birthday"
          end
        rescue StandardError => e
          e.message
        end
      end
    end
  end
end