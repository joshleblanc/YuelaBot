class CreateProxies < ActiveRecord::Migration[5.2]
  def change
    create_table :so_chat_proxies do |t|
      t.integer :room_id
      t.string :server_id
      t.string :channel_id
    end
  end
end
