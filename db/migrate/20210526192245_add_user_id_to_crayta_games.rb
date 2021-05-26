class AddUserIdToCraytaGames < ActiveRecord::Migration[6.1]
  def change
    add_reference :crayta_games, :crayta_user, null: false, foreign_key: true
  end
end
