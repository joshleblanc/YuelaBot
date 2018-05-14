module Commands
  class ListBirthdayCommand
    class << self
      def name
        [:lbd, :list_bdays]
      end

      def attributes
        {
            min_args: 0,
            max_args: 0,
            description: "PM the list of birthdays to the caller",
            usage: "[list_bdays][lbd]"
        }
      end

      def command
        lambda do |e|
          birthdays = Birthday.all.map(&:to_s).join("\n")
          if birthdays.empty?
            "No birthdays found"
          else
            e.user.pm birthdays
          end
        end
      end
    end
  end
end