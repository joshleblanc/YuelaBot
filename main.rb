require 'discordrb'

TOKEN = File.read('config')
bot = Discordrb::Bot.new token: TOKEN

bot.message(starting_with: '!!s') do |event|
  messages = JSON.parse(Discordrb::API::Channel.messages(TOKEN, event.channel.id, 100).body)
  message = event.message.content.split(' ').first
  parts = message.split('/', -1)

  regex = /#{Regexp.quote(parts[1])}/
  target = messages.find { |m| m['content'].match(regex) && m['id'] != event.message.id }
  if target
    if parts[3] === 'g'
      target['content'].gsub! regex, parts[2]
    else
      target['content'].sub! regex, parts[2]
    end
    event.respond target['content']
  end
end

bot.run