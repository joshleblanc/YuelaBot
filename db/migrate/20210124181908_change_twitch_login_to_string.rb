class ChangeTwitchLoginToString < ActiveRecord::Migration[6.1]
  def change
    change_column :twitch_streams, :twitch_login, :string
  end
end
