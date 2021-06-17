class AddCraytaGameCountToCraytaUser < ActiveRecord::Migration[6.1]
  def change
    add_column :crayta_users, :crayta_games_count, :integer
  end
end
