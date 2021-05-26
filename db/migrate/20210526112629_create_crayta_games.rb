class CreateCraytaGames < ActiveRecord::Migration[6.1]
  def change
    create_table :crayta_games do |t|
      t.uuid :external_id
      t.string :name
      t.string :description
      t.datetime :external_created_at
      t.datetime :external_updated_at
      t.boolean :published
      t.boolean :hidden
      t.boolean :publically_editable
      t.boolean :system_game
      t.boolean :copyable
      t.boolean :concealed
      t.boolean :archived
      t.uuid :cover_image
      t.integer :up_votes
      t.integer :down_votes
      t.integer :visits
      t.integer :max_players
      t.string :state_share_url
      t.boolean :blocked
      t.string :game_link
      t.boolean :binned

      t.timestamps
    end
  end
end
