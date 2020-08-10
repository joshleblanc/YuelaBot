require 'active_record'
require 'discordrb'
require 'google/apis/customsearch_v1'
require 'google/apis/youtube_v3'
require 'google/apis/translate_v2'
require 'redd'
require 'rbconfig'
require 'require_all'
require 'csv'
require 'rufus-scheduler'
require 'faye/websocket'
require 'byebug'
require 'mtg_sdk'
require 'mini_racer' unless (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)
require 'octokit'
require 'dotenv/load'
require 'timeout'
require 'steam-api'
require 'nokogiri'
require 'open3'
require 'cowsay'

require_relative 'models/application_record'
require_relative './middleware/application_middleware'

require_all './middleware'
require_all './models'
require_all './commands'
require_all './reactions'
require_all './routines'
require_all './lib'

include Routines
include Middleware

ActiveRecord::Base.configurations = YAML::load(ERB.new(File.read('config/database.yml')).result)
ActiveRecord::Base.establish_connection(ENV['RACK_ENV']&.to_sym || :development)

unless ENV['discord']
    abort "You're missing your discord API token! put discord=<your token here> in a .env file"
end

GLOBAL_MIDDLEWARE = [
  CheckAboveMiddleware.new, 
  SelfPromotionMiddleware.new
]

BOT = Discordrb::Commands::CommandBot.new({
    token: ENV['discord'],
    prefix: '!!',
    log_level: :debug,
    parse_self: true
})

User.where(banned: true).each do |user|
  BOT.ignore_user user.id
end

if ENV['admins']
    ENV['admins'].split(',').each do |admin|
        BOT.set_user_permission(admin.to_i, 1)
    end
end

Afk.destroy_all
UserCommand.all.each do |command|
  BOT.command(command.name.to_sym, &command.method(:run))
end

BOT.command(:ping) do |event|
  event.respond "pong"
end

Commands.constants.map do |c|
  command = Commands.const_get(c)
  command.is_a?(Class) ? command : nil
end.compact.each do |command|
  method = command.method(:command).to_proc
  middleware = GLOBAL_MIDDLEWARE
  if command.respond_to?(:middleware)
    middleware.push *command.middleware
  end
  method.define_singleton_method(:call) do |event, *args|
    begin
      transformed_args = args.dup
      middleware.each do |m|
        transformed_args = m.before(event, *transformed_args)
      end
      transformed_output = super(event, *transformed_args)
      middleware.each do |m|
        transformed_output = m.after(event, transformed_output, *transformed_args)
      end
      transformed_output
    rescue StandardError => e
      e.message
    end
  end
  BOT.command(command.name, command.attributes, &method)
end

Reactions.constants.map do |r|
  reaction = Reactions.const_get(r)
  reaction.is_a?(Class) ? reaction : nil
end.compact.each do |reaction|
  BOT.message(reaction.attributes, &reaction.method(:command))
end

BOT.message_edit(&method(:archive_routine))

typing = {}
last_typing_message = {}
BOT.typing do |event|
  now = Time.now
  typing[event.channel.id] ||= {}
  typing[event.channel.id][event.user.id] = event.timestamp

  typing[event.channel.id].reject! do |k, v|
    now - v > 5
  end
  last_typing_event = last_typing_message[event.channel.id]
  if typing[event.channel.id].count > 3
    if last_typing_event.nil? || now - last_typing_event > 60
      event.respond "https://cdn.discordapp.com/attachments/550684271220752406/552906458421919771/unknown.png"
      last_typing_message[event.channel.id] = event.timestamp
      typing[event.channel.id] = {}
    end
  end
end

BOT.message do |event|
  next if event.from_bot?
  author_id = event.author.id
  user = User.find_or_create_by(id: author_id)
  proxies = SoChatProxy.where(channel_id: event.channel.id)
  proxies.each do |p|
    cookie = user.so_chat_cookies.find_by(url: SoChat.base_url(p.meta))
    if p.send_message(event.message.content, cookie)
      event.message.delete
    else
      event << "#{event.author.mention}, please sign in using !!so_login or !!so_login meta to send messages"
    end
  end

  urs = UserReaction.all.select do |ur|
    Regexp.new(ur.regex).match event.message.content
  end
  urs.each do |ur|
    if rand <= ur.chance
      output = ur.output.sub(":user", event.author.mention)
      event.respond(event.message.content.sub(/#{ur.regex}/, output))
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

BOT.mention do |event|
  crg = CannedResponseGenerator.new
  event << crg.generate(event.author.mention)
end

SoChatProxy.all.each(&:listen!)

scheduler = Rufus::Scheduler.new
scheduler.every '1d', first: :now do
  birthday_routine(BOT)
  LaunchManager.instance.schedule
end
