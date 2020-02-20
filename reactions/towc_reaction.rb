module Reactions
  class TowcReaction
    class << self
      def attributes
        {
            contains: 'towc'
        }
      end

      def command(event)
        if Random.rand < 0.30
          event.message.create_reaction(":towc:441574097843912725")
        end
      end
    end
  end
end
