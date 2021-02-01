module Middleware
  class TypingMiddleware < ApplicationMiddleware
    def before(event, *args)
      event.channel.start_typing

      super
    end
  end
end
