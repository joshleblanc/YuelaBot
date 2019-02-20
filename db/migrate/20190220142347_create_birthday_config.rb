class CreateBirthdayConfig < ActiveRecord::Migration[5.2]
  def change
    create_table :birthday_configs do |t|
      t.integer :server
      t.integer :channel
      t.string :message, length: 500
      t.timestamps
    end
  end
end
