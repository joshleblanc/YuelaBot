class CreateUserCommands < ActiveRecord::Migration[5.2]
  def change
    create_table :user_commands do |t|
      t.string :name
      t.text :input
      t.text :output
      t.string :creator
      t.timestamps
    end
  end
end
