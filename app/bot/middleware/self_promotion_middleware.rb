module Middleware
  class SelfPromotionMiddleware < ApplicationMiddleware
    def before(event, *args)
      @count ||= 0
      @count += 1
      if @count == 1000
        @count = 0
        event.respond "If you like using yuela, consider buying me a coffee <https://buymeacoffee.com/jleblanc>"
      end
      args
    end
  end
end