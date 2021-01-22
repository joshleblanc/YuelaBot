module GemExtensions::Discordrb::Events::MessageEventHandler
  def after_call(event)
    super
    event.sent_message!
  end
end