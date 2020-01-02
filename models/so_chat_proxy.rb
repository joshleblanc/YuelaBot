class SoChatProxy < ApplicationRecord
  def listen!
    so_chat = SoChat.new(channel_id, room_id, ENV['so_user'], ENV['so_pass'], base_url)
    so_chat.listen!
  end
end