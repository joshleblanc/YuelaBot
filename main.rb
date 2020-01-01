require_relative 'bot'

Thread.new do
  require_relative './api/entry.rb'
end

BOT.run