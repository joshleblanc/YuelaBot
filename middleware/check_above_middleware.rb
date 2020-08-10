module Middleware
  class CheckAboveMiddleware < ApplicationMiddleware
    def before(event, *args)
      args.each_with_index do |a, i|
        match = a.match /^\^+$/
        next if match.nil?

        history_index = match[0].size
        args[i] = event.channel.history(history_index + 1).last.content.split(' ')
      end
      args.flatten
    end
  end
end
