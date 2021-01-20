module Commands
  class AddBirthdayCommand
    class << self
      def name
        :add_bday
      end

      def attributes
        {
            min_args: 1,
            max_args: 3,
            description: "Add a birthday for a user",
            usage: "[add_bday][abd] [@user] [month (Number)] [day (Number)]",
            aliases: [:abd]
        }
      end

      def command(event, user, month = nil, day = nil)
        return if event.from_bot?
        begin
          mention = event.message.mentions.first
          if Birthday.find_by(user_id: mention.id, server: event.server.id)
            "A birthday already exists for that user"
          else
            user = User.find_or_create_by(id: mention.id) do |u|
              u.name = mention.name
            end
            if month.nil? && day.nil?
              now = Time.now
              month = now.month
              day = now.day
              event.respond "Defaulting to month: #{month}, day: #{day}. Is this okay? (y/n)"
              response = event.user.await!
              return unless response.message.content.downcase.start_with? 'y'
            elsif day.nil?
              return "If you provide a month, you must provide a day"
            end
            user.birthdays << Birthday.new(
              month: month.to_i,
              day: day.to_i,
              server: event.server.id
            )
            user.save
            "Saved #{mention.name}'s birthday"
          end
        rescue StandardError => e
          e.message
        end
      end
    end
  end
end