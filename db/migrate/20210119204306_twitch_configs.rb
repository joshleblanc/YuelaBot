class TwitchConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :twitch_configs do |t|
      t.integer :server, limit: 8
      t.integer :channel, limit: 8
    end
  end
end
