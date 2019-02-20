class CreateUserReactions < ActiveRecord::Migration[5.2]
  def change
    create_table :user_reactions do |t|
      t.string :regex
      t.text :output
      t.string :creator
      t.float :chance, default: 1
      t.timestamps
    end
  end
end
