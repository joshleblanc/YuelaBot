module Commands
  class AddBirthdayCommand
    class << self
      def name
        [:add_bday, :abd]
      end

      def attributes
        {
          min_args: 3,
          description: "Add a birthday for a user",
          usage: "[add_bday][abd] [user] [month (Number)] [day (Number)]"
        }
      end

      def command
        lambda do |e, *args|
          birthday = Birthday.first(user: args[1])
          if birthday
            "A birthday already exists for that user"
          else
            begin
              month = Integer(args[1])
              day = Integer(args[2])
              Birthday.create(
                user: args[0],
                month: args[1],
                day: args[2]
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