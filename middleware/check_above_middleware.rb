module Middleware
  class CheckAboveMiddleware < ApplicationMiddleware
    def before(event, *args)
      check = args.join(' ')
      if check == '^'
        args = event.channel.history(1, event.message.id).first.content.split(' ')
      end
      args
    end
  end
end
