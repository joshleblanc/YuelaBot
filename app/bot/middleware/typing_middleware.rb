module Middleware
  class TypingMiddleware < ApplicationMiddleware
    def before(event, *args)
      @thread = Thread.new do
        loop do
          break if event.sent_message?

          event.channel.start_typing
          sleep 5
        end
      end
      super
    end

    def cleanup
      @thread.terminate
    end
  end
end
