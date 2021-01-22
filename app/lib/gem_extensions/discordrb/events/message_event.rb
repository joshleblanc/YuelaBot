module GemExtensions::Discordrb::Events::MessageEvent
  def sent_message!
    @sent_message = true
  end
  
  def sent_message?
    @sent_message.present?
  end
end
