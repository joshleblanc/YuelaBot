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

      def command
        lambda do |e, user, month, day|
          user_id = user.match(/<@!?(\d+)>/)[1]
          mention = e.message.mentions.first
          p mention.id, user_id
          if mention.id != user_id.to_i
            return "User must be mentioned"
          end

          user = User.get(user_id)
          if Birthday.first(user: user, server: e.server.id)
            "A birthday already exists for that user"
          else
            begin
              user = User.first_or_new(id: mention.id)
              user.name = mention.name
              Birthday.create(
                user: user,
                month: Integer(month),
                day: Integer(day),
                server: e.server.id
              )
            rescue Exception => _
              "Usage: `#{self.attributes[:usage]}`"
            end
          end
        end
      end
    end
  end
end