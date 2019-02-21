class CreateBirthdays < ActiveRecord::Migration[5.2]
  def change
    create_table :birthdays do |t|
      t.integer :month
      t.integer :day
      t.integer :server, limit: 8
      t.references :user
      t.timestamps
    end
  end
end
