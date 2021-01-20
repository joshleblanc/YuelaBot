class CreateTwitchStreamEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :twitch_stream_events do |t|
      t.json :data
      t.integer :server, limit: 8
      t.integer :twitch_user_id

      t.timestamps
    end
  end
end
