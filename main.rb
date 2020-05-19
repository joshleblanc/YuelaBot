require_relative 'bot'

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular 'cookie', 'cookies'
end

Thread.new do
  require_relative './site/entry.rb'
end

BOT.run