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
#
# Indexes
#
#  index_bot_messages_on_server_id                 (server_id)
#  index_bot_messages_on_server_id_and_created_at  (server_id,created_at)
#  index_bot_messages_on_user_id                   (user_id)
#

class BotMessage < ApplicationRecord
  belongs_to :user
  belongs_to :server
  
  validates :role, inclusion: { in: %w[user assistant system] }
  validates :content, presence: true
  
  scope :for_server, ->(server_id) { where(server_id: server_id) }
  scope :recent, ->(limit = 50) { order(created_at: :desc).limit(limit) }
  scope :conversation_history, ->(server_id, limit = 20) { 
    for_server(server_id).recent(limit).order(:created_at) 
  }
  
  def self.add_user_message(server_id:, user_id:, content:, message_id: nil)
    create!(
      server_id: server_id,
      user_id: user_id,
      content: content,
      role: 'user',
      message_id: message_id
    )
  end
  
  def self.add_assistant_message(server_id:, user_id:, content:, message_id: nil)
    create!(
      server_id: server_id,
      user_id: user_id,
      content: content,
      role: 'assistant',
      message_id: message_id
    )
  end
end
