class SoChatProxy < ApplicationRecord
  def listen!
    so_chat = SoChat.new(channel_id, room_id, ENV['so_user'], ENV['so_pass'])
    so_chat.listen!
  end

  def stop!

  end
end