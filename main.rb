require 'discordrb'

Discordrb::Commands::CommandBot.new token: File.read('bot'), prefix: '!'

bot.command()
bot.message(with_text: 'Ping!') do |event|
  event.respond 'Pong!'
end

bot.run