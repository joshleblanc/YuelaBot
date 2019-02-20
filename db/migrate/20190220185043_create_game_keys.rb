class CreateGameKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :game_keys do |t|
      t.string :name
      t.string :key
      t.timestamps
    end
  end
end
