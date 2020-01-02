class SoChatProxy < ApplicationRecord
  def listen!
    so_chat = SoChat.new(channel_id, room_id, ENV['so_user'], ENV['so_pass'], meta)
    so_chat.listen!
  end

  def url
    if meta
      "https://chat.meta.stackexchange.com/rooms/#{room_id}"
    else
      "https://chat.stackoverflow.com/rooms/#{room_id}"
    end
  end
end