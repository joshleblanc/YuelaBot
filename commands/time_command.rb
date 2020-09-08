module Commands
  class TimeCommand
    class << self
      def name
        :time
      end

      def attributes
        {
          description: "Displays the current time in a timezone",
          usage: "time <timezone>",
          aliases: []
        }
      end

      def command(event, *args)
        return if event.from_bot?
        return "Please pass a timezone" if args.empty?
        timezone = args.join(' ')
        timezone_identifier = (timezone.length == 2) ? TZInfo::Country.get(timezone).zone_info.first.identifier : TZInfo::Timezone.get(timezone)
        # Use block so we don't break anything else
        Time.use_zone(timezone_identifier) { Time.zone.now }
      end
    end
  end
end
