gem 'json', '=1.8.6'

require 'active_record'
require 'discordrb'
require 'google/apis/customsearch_v1'
require 'fourchan/kit'
require 'redd'
require 'require_all'
require 'data_mapper'
require 'csv'
require 'rufus-scheduler'
require 'faye/websocket'
require 'byebug'
require 'mtg_sdk'
require 'mini_racer'
require 'dotenv/load'

require_relative 'models/application_record'
require_all './models'
require_all './commands'
require_all './reactions'
require_all './routines'
require_all './room-17-proxy'

include Routines
DataMapper.setup(:default, "sqlite://#{Dir.home}/yuela")
DataMapper.repository(:default).adapter.select("PRAGMA synchronous=OFF")
DataMapper.repository(:default).adapter.select("PRAGMA journal_mode=WAL")
DataMapper::Model.raise_on_save_failure = true
DataMapper.finalize.auto_upgrade!

ActiveRecord::Base.configurations = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(ENV['RACK_ENV'] || :development)


BOT = Discordrb::Commands::CommandBot.new({
  token: ENV['discord'],
  prefix: '!!',
  log_level: :debug,
  parse_edited: true
})

ENV['admins'].split(',').each do |admin|
  BOT.set_user_permission(admin.to_i, 1)
end

Afk.destroy_all
UserCommand.all.each do |command|
  BOT.command(command.name.to_sym, &command.run)
end

Commands.constants.map do |c|
  command = Commands.const_get(c)
  command.is_a?(Class) ? command : nil
end.compact.each do |command|
  BOT.command(command.name, command.attributes, &command.method(:command))
end

Reactions.constants.map do |r|
  reaction = Reactions.const_get(r)
  reaction.is_a?(Class) ? reaction : nil
end.compact.each do |reaction|
  BOT.message(reaction.attributes, &reaction.method(:command))
end

BOT.message do |event|
  urs = UserReaction.all.find_all do |ur|
    Regexp.new(ur.regex).match event.message.content
  end
  urs.each do |ur|
    if rand <= ur.chance
      event.respond(event.message.content.sub(/#{ur.regex}/, ur.output))
    end
  end

  user_ids = event.message.mentions.map(&:id)
  user_ids.each do |uid|
    user = User.find_by(id: uid)
    if user&.afk
      out = ''
      out << "#{user.name} is afk"
      out << ": #{user.afk.message}" if user.afk.message
      event << out
    end
  end
end

scheduler = Rufus::Scheduler.new

scheduler.every '1d', first: :now do
  birthday_routine(BOT)
end

room17 = Room17Proxy.new(ENV['channel_id'], ENV['room_id'], ENV['so_user'], ENV['so_pass'])
room17.listen!

BOT.run
