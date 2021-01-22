module GemExtensions
  module Discordrb
    module Events
      module MessageEventHandler
        def after_call(event)
          super
          event.sent_message!
        end
      end
    end
  end
end