class AddDiscordInfoToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :avatar_url, :string
    add_column :users, :email, :string
  end
end
