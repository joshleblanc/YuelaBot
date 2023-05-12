module Reactions
  class JordanReaction
    class << self
      def attributes
        {}
      end
      
      def command(event)
        return unless event.author.id.to_s == "276800358037061633" 
        if Random.rand < 0.05
          event.respond "very fancy"
        end
      end
    end
  end
end
