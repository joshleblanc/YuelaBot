class CreateUserReactionServers < ActiveRecord::Migration[6.1]
  def change
    create_table :user_reaction_servers do |t|
      t.references :user_reaction, null: false, foreign_key: true
      t.references :server, null: false, foreign_key: true

      t.timestamps
    end
  end
end
