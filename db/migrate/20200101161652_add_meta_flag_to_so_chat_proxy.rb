class AddMetaFlagToSoChatProxy < ActiveRecord::Migration[5.2]
  def change
    add_column :so_chat_proxies, :meta, :boolean, default: false
  end
end
