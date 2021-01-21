class CreateServerPrefixes < ActiveRecord::Migration[6.1]
  def change
    create_table :server_prefixes do |t|
      t.integer :server, limit: 8
      t.string :prefix

      t.timestamps
    end
  end
end
