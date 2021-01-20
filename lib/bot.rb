include Routines::ArchiveRoutine
include Routines::BirthdayRoutine
include Middleware
include Helpers::InjectMiddleware

unless ENV['DISCORD']
    abort "You're missing your discord API token! put discord=<your token here> in a .env file"
end

GLOBAL_MIDDLEWARE = [
  CheckAboveMiddleware.new, 
  SelfPromotionMiddleware.new
]

BOT = Discordrb::Commands::CommandBot.new({
    token: ENV['DISCORD'],
    prefix: '!!',
    log_level: :debug,
    parse_self: true
})

User.where(banned: true).each do |user|
  BOT.ignore_user user.id
end

if ENV['ADMINS']
    ENV['ADMINS'].split(',').each do |admin|
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

def find_commands(mod)
  mod.constants.map do |c|
    command = mod.const_get(c)
    case command
    when Class
      command
    when Module
      find_commands(command)
    else
      nil
    end
  end
end

find_commands(Commands).flatten.compact.each do |command|
  BOT.command(command.name, command.attributes, &inject_middleware(command))
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

  urs = UserReaction.all.select do |ur|
    Regexp.new(ur.regex).match(event.message.content) && event.server.id == ur.server
  end
  urs.each do |ur|
    if rand <= ur.chance
      ur.trigger event
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

scheduler = Rufus::Scheduler.new
scheduler.every '1d', first: :now do
  birthday_routine(BOT)
  LaunchManager.instance.schedule
end

scheduler.every '1m' do
  TwitchStreamEvent.each do |event|
    twitch_configs = TwitchConfig.where(server: event.server)
    event.data.each do |datum|
      embed = Discordrb::Webhooks::Embed.new
      case datum["type"]
      when "live"
        embed.title "#{datum["user_name"]} is now live on Twitch!"
      end
      twitch_configs.each do |config|
        BOT.send_message(config.channel, nil, nil, embed)
      end
    end
  end
end

BOT.run