class CreateProxyConfig < ActiveRecord::Migration[5.2]
  def change
    create_table :so_chat_proxy_configs do |t|
      t.string :server_id
      t.string :channel_id
    end
  end
end
