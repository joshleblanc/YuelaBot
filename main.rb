gem 'json', '=1.8.6'

require 'discordrb'
require 'rbnacl/libsodium'
require 'google/apis/customsearch_v1'
require 'fourchan/kit'
require 'require_all'

require_all './commands'
require_all './reactions'

CONFIG = File.read('config').lines.each_with_object({}) do |l,o|
  parts = l.split('=')
  o[parts[0]] = parts[1].strip
end

bot = Discordrb::Commands::CommandBot.new token: CONFIG['discord'], prefix: '!!'

Commands.constants.map do |c|
  command = Commands.const_get(c)
  command.is_a?(Class) ? command : nil
end.compact.each do |command|
  bot.command(command.name, command.attributes, &command.command)
end

Reactions.constants.map do |r|
  reaction = Reactions.const_get(r)
  reaction.is_a?(Class) ? reaction : nil
end.compact.each do |reaction|
  bot.message(reaction.attributes, &reaction.command)
end

bot.run
