class CreateGameKeyServers < ActiveRecord::Migration[6.1]
  def change
    create_table :game_key_servers do |t|
      t.references :game_key, null: false, foreign_key: true
      t.references :server, null: false, foreign_key: true

      t.timestamps
    end
  end
end
