module Middleware
  class TypingMiddleware < ApplicationMiddleware
    def before(event, *args)
      @thread = Thread.new do
        loop do
          p "start typing"
          event.channel.start_typing
          sleep 5
        end
      end
      super
    end

    def after(event, *args)
      p "stop typing"
      @thread.terminate
      super
    end
  end
end
