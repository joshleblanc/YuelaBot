class AddChannelIdToBotMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :bot_messages, :channel_id, :bigint

    add_index :bot_messages, :channel_id
    add_index :bot_messages, [:channel_id, :created_at]
  end
end
