class BotConversationService
  def initialize(channel_id:, user_id:, server_id: nil, bot_user: nil)
    @channel_id = channel_id
    @server_id = server_id
    @user_id = user_id
    @bot_user = bot_user
  end

  def add_user_message(content:, message_id: nil)
    BotMessage.add_user_message(
      server_id: @server_id,
      channel_id: @channel_id,
      user_id: @user_id,
      content: content,
      message_id: message_id
    )
  end

  def add_assistant_message(content:, message_id: nil)
    BotMessage.add_assistant_message(
      server_id: @server_id,
      channel_id: @channel_id,
      user_id: @user_id,
      content: content,
      message_id: message_id
    )
  end

  def build_conversation_history
    # Get recent conversation history for the current context (server if present, else channel)
    server_history = BotMessage.includes(:user).conversation_history(server_id: @server_id, channel_id: @channel_id, limit: 15)
    
    # Get recent messages from the specific user
    user_history = BotMessage.includes(:user)
                             .for_context(server_id: @server_id, channel_id: @channel_id)
                             .where(user_id: @user_id)
                             .recent(5)
                             .order(:created_at)

    # Combine and deduplicate
    all_messages = (server_history + user_history).uniq.sort_by(&:created_at)
    
    # Convert to Venice API format
    messages = []
    
    # Add system prompt with context
    messages << {
      role: 'system',
      content: build_system_prompt
    }
    
    # Add conversation history
    all_messages.each do |msg|
      # For assistant messages, don't prefix with username since it's the bot
      if msg.role == 'assistant'
        messages << {
          role: msg.role,
          content: msg.content
        }
      else
        # For user messages, include username and preserve mentions
        messages << {
          role: msg.role,
          content: "#{msg.user.name}: #{msg.content}"
        }
      end
    end
    
    messages
  end

  private

  def build_system_prompt
    base_prompt = <<~PROMPT
      Be Direct: Answer the prompt immediately without preamble ("Sure!", "I can help with that").

      Style: Use a casual, low-stakes tone. Think "knowledgeable friend," not "helpful butler."

      Grammar: Use sentence-case or lowercase. Minimize exclamation points. Avoid professional "corporate-speak."

      No Mirroring: Do not repeat the user's intent back to them (e.g., "I see you're asking about...").

      Conciseness: Give the shortest useful answer possible. If they want more detail, they will ask.

      No Questions: Do not end your message with a "hook" or a question to keep the conversation going unless specifically asked to facilitate a discussion.

      No "This or That": Do not end your message with a "This or That" question.

      Don't state you're okay with anything

      Conversation context: prior user messages are formatted like "username: message". The "username:" portion is metadata indicating who spoke, and is not part of the message content. Do not treat the username as a topic or target.

      Replies: if a user message starts with something like [Replying to NAME: "..."] or [User is replying to your previous message: "..."], that bracketed text is reply context. Use NAME when helpful to refer to who is being replied to.
    PROMPT

    # Add bot identity information
    if @bot_user
      base_prompt += "\n\nYour username is #{@bot_user.username}"
      base_prompt += " (display name: #{@bot_user.display_name})" if @bot_user.display_name != @bot_user.username
      base_prompt += ". When people mention @#{@bot_user.username} or you see your username in messages, they're talking to you."
    end

    base_prompt += "\n\nRespond a patronizing way -- similar to a reddit user responding to a post they're knowledgable about"
    

    base_prompt
  end
end