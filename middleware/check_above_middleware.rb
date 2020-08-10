module Middleware
  class CheckAboveMiddleware < ApplicationMiddleware

    def do_replacements(event, args, message = nil)
      args.each_with_index do |a, i|
        match = a.match /^\^+$/
        next if match.nil?

        history_index = match[0].size
        next_message = event.channel.history(history_index, message).last
        next_args = next_message.content.split(' ')
        do_replacements(event, next_args, next_message.id)
        args[i] = next_args
      end
      
    end

    def before(event, *args)
      do_replacements(event, args, event.message.id)
      args.flatten
    end
  end
end
