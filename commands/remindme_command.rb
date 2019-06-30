module Commands
  class RemindMeCommand
    class << self
      def name
        :remind
      end

      def attributes
        {
            usage: 'remind [time] [message]',
            min_args: 2,
            description: 'Reminds the user after an allocated time has passed. [time] defaults to minutes, but you can specify the unit with "h", "m", "s", etc.',
            aliases: [:rm, :remindme]
        }
      end

      def command(event, time, *args)
        return if event.from_bot?
        message = args.join(' ')

        # Assume the time is coming in as an integer without a duration
        # If it is, give it a minutes duration, if it's not, pass it through
        time = "#{Integer(time)}m" rescue time

        begin
          Rufus::Scheduler.singleton.in time do
            event.respond "<@#{event.author.id}> #{message}"
          end
          event.respond "Okay <@#{event.author.id}>, I'll remind you to #{message} in #{time}"
        rescue Exception => err
          event.respond err.message
        end
        nil
      end
    end
  end
end