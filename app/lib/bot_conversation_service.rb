class BotConversationService
  def initialize(server_id:, user_id:)
    @server_id = server_id
    @user_id = user_id
  end

  def add_user_message(content:, message_id: nil)
    BotMessage.add_user_message(
      server_id: @server_id,
      user_id: @user_id,
      content: content,
      message_id: message_id
    )
  end

  def add_assistant_message(content:, message_id: nil)
    BotMessage.add_assistant_message(
      server_id: @server_id,
      user_id: @user_id,
      content: content,
      message_id: message_id
    )
  end

  def build_conversation_history
    # Get recent conversation history for the server
    server_history = BotMessage.includes(:user).conversation_history(@server_id, 15)
    
    # Get recent messages from the specific user
    user_history = BotMessage.includes(:user).where(server_id: @server_id, user_id: @user_id)
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
      messages << {
        role: msg.role,
        content: "#{msg.user.name}: #{msg.content}"
      }
    end
    
    messages
  end

  private

  def build_system_prompt
    base_prompt = "You are a helpful Discord bot assistant. Keep responses under 2000 characters and be conversational but concise."
    
    base_prompt
  end
end