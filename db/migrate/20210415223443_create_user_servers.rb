class CreateUserServers < ActiveRecord::Migration[6.1]
  def change
    create_table :user_servers do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :server, null: false, foreign_key: true
      t.boolean :owner

      t.timestamps
    end
  end
end
