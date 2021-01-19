class TwitchStreams < ActiveRecord::Migration[5.2]
  def change
    create_table :twitch_streams do |t|
      t.datetime :expires_at
      t.integer :server, limit: 8
      t.integer :twitch_login
    end
  end
end
