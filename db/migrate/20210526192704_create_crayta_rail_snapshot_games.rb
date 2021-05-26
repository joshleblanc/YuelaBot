class CreateCraytaRailSnapshotGames < ActiveRecord::Migration[6.1]
  def change
    create_table :crayta_rail_snapshot_games do |t|
      t.references :crayta_rail_snapshot, null: false, foreign_key: true
      t.references :crayta_game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
