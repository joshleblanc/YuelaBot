include Routines::ArchiveRoutine
include Routines::BirthdayRoutine
include Middleware
include Helpers::InjectMiddleware

unless ENV['DISCORD']
    abort "You're missing your discord API token! put discord=<your token here> in a .env file"
end

GLOBAL_MIDDLEWARE = [
  CheckAboveMiddleware,
  SelfPromotionMiddleware,
  TypingMiddleware
]

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
  next unless event.server.present?

  author_id = event.author.id
  user = User.find_or_create_by(id: author_id)

  urs = UserReaction.joins(:servers).where(servers: { external_id: event.server.id }).select do |ur|
    Regexp.new(ur.regex).match(event.message.content)
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
  next if event.from_bot?
  next unless event.server.present?
  next if event.user.id.to_s == "152107946942136320"
  
  begin
    # Ensure user exists
    user = User.find_or_create_by(id: event.author.id) do 
      _1.name = e.author.name
    end
    
    # Ensure server exists
    server = Server.find_or_create_by(external_id: event.server.id) do |s|
      s.name = event.server.name
    end

    # Initialize conversation service
    conversation = BotConversationService.new(
      server_id: server.id,
      user_id: user.id,
      bot_user: BOT.profile
    )


    # Preserve original content with mentions for storage
    original_content = event.message.content
    
    # Clean the message content (remove bot mention) for processing
    content = event.message.content.gsub(/<@!?#{BOT.profile.id}>/, '').strip

    # Check if this is a reply and include reply context
    if event.message.reply?
      referenced_msg = event.message.referenced_message
      if referenced_msg
        reply_author = referenced_msg.author.display_name || referenced_msg.author.username
        reply_content = referenced_msg.content
        
        # Truncate long messages for context
        reply_content = reply_content[...500] + "..." if reply_content.length > 500
        
        # Build context string
        reply_context = "[Replying to #{reply_author}: \"#{reply_content}\"]"
        
        # Prepend reply context to user's message
        content = "#{reply_context} #{content}".strip
        # Also add reply context to original content for storage
        original_content = "#{reply_context} #{original_content}".strip
      end
    end
    
    # Resolve user mentions to usernames for better context
    if event.message.mentions.any?
      event.message.mentions.each do |mentioned_user|       
        # Replace mention with username for better readability
        username = mentioned_user.display_name || mentioned_user.username
        mention_pattern = /<@!?#{mentioned_user.id}>/
        content = content.gsub(mention_pattern, "@#{username}")
        original_content = original_content.gsub(mention_pattern, "@#{username}")
      end
    end
    
    # If no content after removing mention, use a default prompt
    content = "Hello!" if content.empty?

    # Add user message to history (preserve original with mentions)
    conversation.add_user_message(
      content: original_content,
      message_id: event.message.id
    )

    # Build conversation history
    messages = conversation.build_conversation_history

    p content 
    # Add current user message
    messages << { role: 'user', content: content }

    # Call Venice API
    client = VeniceClient::ChatApi.new
    response = client.create_chat_completion(
      chat_completion_request: {
        model: "venice-uncensored", #FetchTraitsJob.perform_now("text")["most_uncensored"],
        messages: messages,
        venice_parameters: {
          strip_thinking_response: true
        }
      }
    )

    # Extract and clean response
    bot_response = response.choices.first.message.content
    bot_response = bot_response.gsub(/<think>.*?<\/think>/m, "").strip
    bot_response = bot_response[...2000] # Ensure under Discord limit

    # Send response
    event << bot_response

    # Add assistant response to history
    conversation.add_assistant_message(
      content: bot_response
    )

  rescue => e
    # Fallback to canned response on error
    p "Bot mention error: #{e.message}, #{e.backtrace}"
    crg = CannedResponseGenerator.new
    event << crg.generate(event.author.mention)
  end
end

scheduler = Rufus::Scheduler.new
scheduler.every '1d', first: :now do
  birthday_routine(BOT)
  LaunchManager.instance.schedule
end

scheduler.every '1m' do
  TwitchStream.all.each(&:renew)

  TwitchStreamEvent.all.each do |event|
    twitch_configs = TwitchConfig.where(server: event.server)
    event.data.each do |datum|
      user = Apis::Twitch.user(login: datum["user_name"])
      embed = Discordrb::Webhooks::Embed.new
      case datum["type"]
      when "live"
        embed.title = "#{datum["user_name"]} is now live on Twitch!"
        embed.url = "https://twitch.tv/#{datum["user_name"]}"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: datum["thumbnail_url"])
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: datum["user_name"], url: user["profile_image_url"])
        twitch_configs.each do |config|
          BOT.send_message(config.channel, nil, nil, embed)
        end
      end
    end
    event.destroy
  end
end
