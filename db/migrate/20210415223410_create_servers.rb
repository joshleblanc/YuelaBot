class CreateServers < ActiveRecord::Migration[6.1]
  def change
    create_table :servers do |t|
      t.bigint :external_id
      t.string :name
      t.string :icon

      t.timestamps
    end
  end
end
