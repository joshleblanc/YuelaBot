# == Schema Information
#
# Table name: bot_messages
#
#  id         :integer          not null, primary key
#  server_id  :integer
#  user_id    :integer
#  content    :text
#  role       :string
#  message_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  channel_id :integer
#
# Indexes
#
#  index_bot_messages_on_channel_id                 (channel_id)
#  index_bot_messages_on_channel_id_and_created_at  (channel_id,created_at)
#  index_bot_messages_on_server_id                  (server_id)
#  index_bot_messages_on_server_id_and_created_at   (server_id,created_at)
#  index_bot_messages_on_user_id                    (user_id)
#

class BotMessage < ApplicationRecord
  belongs_to :user
  belongs_to :server, optional: true
  
  validates :role, inclusion: { in: %w[user assistant system] }
  validates :content, presence: true
  validates :channel_id, presence: true
  
  scope :for_server, ->(server_id) { where(server_id: server_id) }
  scope :for_channel, ->(channel_id) { where(channel_id: channel_id) }
  scope :for_context, ->(server_id:, channel_id:) do
    if server_id.present?
      for_server(server_id)
    else
      for_channel(channel_id)
    end
  end
  scope :recent, ->(limit = 50) { order(created_at: :desc).limit(limit) }
  scope :conversation_history, ->(server_id:, channel_id:, limit: 20) do
    for_context(server_id: server_id, channel_id: channel_id).recent(limit).order(:created_at)
  end
  
  def self.add_user_message(channel_id:, user_id:, content:, message_id: nil, server_id: nil)
    create!(
      server_id: server_id,
      channel_id: channel_id,
      user_id: user_id,
      content: content,
      role: 'user',
      message_id: message_id
    )
  end
  
  def self.add_assistant_message(channel_id:, user_id:, content:, message_id: nil, server_id: nil)
    create!(
      server_id: server_id,
      channel_id: channel_id,
      user_id: user_id,
      content: content,
      role: 'assistant',
      message_id: message_id
    )
  end
end
