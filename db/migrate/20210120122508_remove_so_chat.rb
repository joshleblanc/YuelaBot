class RemoveSoChat < ActiveRecord::Migration[5.2]
  def change
    drop_table :so_chat_cookies
    drop_table :so_chat_proxy_configs
    drop_table :so_chat_proxies
  end
end
