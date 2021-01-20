module Commands
  class RemindmeCommand
    class << self
      def name
        :remind
      end

      def attributes
        {
            min_args: 2,
            description: <<~USAGE,
            Reminds the user after an allocated time has passed. [time] defaults to minutes, but you can specify the unit with "h", "m", "s", etc.
              #{options_parser.usage}
            USAGE
            aliases: [:rm, :remindme]
        }
      end

      def options_parser
        @options_parser ||= OptionsParserMiddleware.new do |option_parser, options|
          options[:r] = false

          option_parser.banner = "Usage: remindme [options] time message"

          option_parser.on("-r", "--repeat", "") do
            options[:r] = true
          end
        end
      end

      def middleware
        [
          options_parser
        ]
      end

      def command(event, options, time, *args)
        return if event.from_bot?
        message = args.join(' ')
        repeat = options[:r]

        # Assume the time is coming in as an integer without a duration
        # If it is, give it a minutes duration, if it's not, pass it through
        time = "#{Integer(time)}m" rescue time

        parsed_time = Fugit::Duration.parse(time)
        time_in_seconds = parsed_time.to_sec
        rufus_time = "#{time_in_seconds}s"
        time_string = parsed_time.to_long_s

        if time_in_seconds < 3600 && repeat
          event.respond "Since this reminder is less than 1 hour, it cannot repeat."
          repeat = false
        end
      

        repititions = 0
        reminder = ->(job) do
          remind_str = "<@#{event.author.id}> #{message}." 
          remind_str += " I'll remind you again in #{time_string}. Say \"stop\" to stop." if repeat 
          event.respond remind_str
          next unless repeat
          repititions += 1
          response = event.user.await!(timeout: [job.frequency, 60].min)
          if response&.content&.downcase == "stop" || repititions > 10
            event.respond "Alright. I won't remind you #{message} anymore."
            job.unschedule 
            job.kill
          end
        end

        if repeat
          Rufus::Scheduler.singleton.every(rufus_time, &reminder)
        else
          Rufus::Scheduler.singleton.in(rufus_time, &reminder)
        end

        adverb = repeat ? "every" : "in"
        "Okay <@#{event.author.id}>, I'll remind you #{message} #{adverb} #{time_string}"
      end
    end
  end
end
