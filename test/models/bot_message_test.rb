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

require "test_helper"

class BotMessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
