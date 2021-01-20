module Commands
  class ListBirthdayCommand
    class << self
      def name
        :list_bdays
      end

      def attributes
        {
            min_args: 0,
            max_args: 0,
            description: "PM the list of birthdays to the caller",
            usage: "[list_bdays]",
            aliases: [:lbd]
        }
      end

      def command(e)
        return if e.from_bot?
        birthdays = Birthday.where(server: e.server.id).order(month: :asc, day: :asc).map(&:to_s).join("\n")
        if birthdays.empty?
          "No birthdays found"
        else
          e.user.pm birthdays
        end
      end
    end
  end
end