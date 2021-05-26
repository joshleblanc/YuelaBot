class CreateCraytaUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :crayta_users do |t|
      t.string :name
      t.uuid :external_id

      t.timestamps
    end
  end
end
