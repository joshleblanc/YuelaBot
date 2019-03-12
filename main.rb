require_relative 'bot'


room17 = Room17Proxy.new(ENV['channel_id'], ENV['room_id'], ENV['so_user'], ENV['so_pass'])
room17.listen!

BOT.run
