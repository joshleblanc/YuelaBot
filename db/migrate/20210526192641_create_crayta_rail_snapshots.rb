class CreateCraytaRailSnapshots < ActiveRecord::Migration[6.1]
  def change
    create_table :crayta_rail_snapshots do |t|
      t.references :crayta_rail, null: false, foreign_key: true

      t.timestamps
    end
  end
end
