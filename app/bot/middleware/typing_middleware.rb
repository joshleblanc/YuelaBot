module Middleware
  class TypingMiddleware < ApplicationMiddleware
    def initialize
      @done = false
    end

    def before(event, *args)
      @thread = Thread.new do
        loop do
          break if @done

          event.channel.start_typing
          sleep 5
        end
      end
      super
    end

    def after(event, output, *args)
      @done = true
      super
    end
  end
end
