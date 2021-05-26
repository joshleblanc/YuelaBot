class CreateCraytaRails < ActiveRecord::Migration[6.1]
  def change
    create_table :crayta_rails do |t|
      t.string :name
      t.boolean :current
      t.string :mode

      t.timestamps
    end
  end
end
