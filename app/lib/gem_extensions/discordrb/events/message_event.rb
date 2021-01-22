module GemExtensions
  module Discordrb
    module Events
      module MessageEvent
        def sent_message!
          @sent_message = true
        end
        
        def sent_message?
          @sent_message.present?
        end
      end
    end
  end
end
