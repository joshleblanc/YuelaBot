module Middleware
  def check_above(event, *args)
    check = args.join(' ')
    if check == '^'
      args = event.channel.history(1, event.message.id).first.content.split(' ')
    end
    args
  end
end
