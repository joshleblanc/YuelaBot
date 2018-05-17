gem 'json', '=1.8.6'

require 'discordrb'
require 'rbnacl/libsodium'
require 'google/apis/customsearch_v1'
require 'fourchan/kit'
require 'redd'
require 'require_all'
require 'data_mapper'
require 'csv'
require 'rufus-scheduler'

require_all './commands'
require_all './reactions'
require_all './models'
require_all './routines'

include Routines
DataMapper.setup(:default, "sqlite://#{Dir.home}/yuela")
DataMapper.finalize.auto_upgrade!


CONFIG = File.read('config').lines.each_with_object({}) do |l,o|
  parts = l.split('=')
  o[parts[0]] = parts[1].strip
end

BOT = Discordrb::Commands::CommandBot.new token: CONFIG['discord'], prefix: '!!'

UserCommand.all.each do |command|
  BOT.command(command.name.to_sym, &command.run)
end

Commands.constants.map do |c|
  command = Commands.const_get(c)
  command.is_a?(Class) ? command : nil
end.compact.each do |command|
  BOT.command(command.name, command.attributes, &command.command)
end

Reactions.constants.map do |r|
  reaction = Reactions.const_get(r)
  reaction.is_a?(Class) ? reaction : nil
end.compact.each do |reaction|
  BOT.message(reaction.attributes, &reaction.command)
end

scheduler = Rufus::Scheduler.new

scheduler.every '1d', first: :now do
  birthday_routine(BOT)
end
p 'tmp'
BOT.run
