def CheckAbove(event, *args)
    check = args[0]
    if check === '^'
      args = event.channel.history(1, event.message.id).split(' ')
    end
    args
end