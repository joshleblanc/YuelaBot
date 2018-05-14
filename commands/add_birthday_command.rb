module Commands
  class AddBirthdayCommand
    class << self
      def name
        [:add_bday, :abd]
      end

      def attributes
        {
          min_args: 4,
          max_args: 4,
          description: "Add a birthday for a user",
          usage: "[add_bday][abd] [@user] [month (Number)] [day (Number)] [#channel]"
        }
      end

      def command
        lambda do |e, user, month, day, channel|
          mention = e.message.mentions.first
          if mention.mention != user
            return "User must be mentioned"
          end

          user = User.get(user.match(/<@(\d+)>/)[1])
          if Birthday.first(user: user)
            "A birthday already exists for that user"
          else
            begin
              user = User.first_or_new(id: mention.id)
              user.name = mention.name
              Birthday.create(
                user: user,
                month: Integer(month),
                day: Integer(day),
                channel: channel.match(/<#(\d+)>/)[1]
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