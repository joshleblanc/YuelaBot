require_relative 'bot'
require_relative './site/entry.rb'

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular 'cookie', 'cookies'
end

bot_thread = Thread.new do
  BOT.run
end

server_thread = Thread.new do
  SinatraServer.run!
end

Signal.trap("INT") do
  server_thread.terminate
  bot_thread.terminate
end

[server_thread, bot_thread].each(&:join)



