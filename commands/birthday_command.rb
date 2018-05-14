module Commands
  class BirthdayCommand
    class << self
      def name
        :bday
      end

      def attributes
        {
          min_args: 1
        }
      end

      def command
        lambda do |e, *args|
          case args[0]
          when 'list'
            e.user.pm Birthday.all.map(&:to_s).join("\n")
          when 'add'

          when 'remove'
            birthday = Birthday.first(user: args[1])
            if birthday
              Birthday.destroy
              "Birthday deleted"
            else
              "A birthday doesn't exist for that user"
            end
          end

        end
      end
    end
  end
end