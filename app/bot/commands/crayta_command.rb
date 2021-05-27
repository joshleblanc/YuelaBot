module Commands
  class CraytaCommand
    class << self
      def name
        :crayta
      end

      def attributes
        {
          description: "Watch or unwatch rail activity",
          usage: "crayta watch or crayta unwatch"
        }
      end

      def command(event, *args)
        return if event.from_bot?

        subscription = CraytaRailSubscription.where(channel: event.channel.id).first_or_initialize
        if args.first == "watch" then
          if subscription.persisted? 
            "You're already watching crayta rails in this channel"
          else
            subscription.save
            "Crayta rail changes will be posted to this channel"
          end
        elsif args.first == "unwatch"
          if subscription.persisted?
            subscription.destroy
            "You will no longer receive crayta rail updates in this channel"
          else
            "This channel isn't watching crayta rail updates"
          end
        else
          "Specify watch or unwatch"
        end
      end
    end
  end
end