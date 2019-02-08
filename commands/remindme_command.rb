module Commands
  class RemindMeCommand
    class << self
      def name
        [:rm, :remind]
      end

      def attributes
        {
          usage: 'remind [time] [message]',
          min_args: 2,
          description: 'Reminds the user after an allocated time has passed',
        }
      end

      def command(event, time, *args)
        message = args.join(' ')
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