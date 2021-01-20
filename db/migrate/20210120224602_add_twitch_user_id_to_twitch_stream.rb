class AddTwitchUserIdToTwitchStream < ActiveRecord::Migration[6.1]
  def change
    add_column :twitch_streams, :twitch_user_id, :integer
  end
end
