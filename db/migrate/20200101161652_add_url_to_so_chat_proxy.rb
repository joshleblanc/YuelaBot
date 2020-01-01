class AddUrlToSoChatProxy < ActiveRecord::Migration[5.2]
  def change
    add_column :so_chat_proxies, :base_url, :string, default: "https://chat.stackoverflow.com"
  end
end
