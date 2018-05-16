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
            usage: "[rbd][remove_birthday] [@user]"
        }
      end

      def command
        lambda do |e, mention|
          return unless e.user.id.to_s == CONFIG['user']
          begin
            user_id = mention.match(/<@!?(\d+)>/)[1]
            user = User.get(user_id)
            birthday = user && user.birthdays.first(server: e.server.id)
            return "User does not have a birthday registered" unless user && birthday
            birthday.destroy
            "#{user.name}'s birthday has been forgotten"
          rescue Exception => _
            "Usage: `#{self.attributes[:usage]}`"
          end
        end
      end
    end
  end
end