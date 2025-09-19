class CreateBotMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :bot_messages do |t|
      t.bigint :server_id
      t.bigint :user_id
      t.text :content
      t.string :role
      t.bigint :message_id

      t.timestamps
    end
    
    add_index :bot_messages, :server_id
    add_index :bot_messages, :user_id
    add_index :bot_messages, [:server_id, :created_at]
  end
end
