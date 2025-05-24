# == Schema Information
#
# Table name: twitch_stream_events
#
#  id             :integer          not null, primary key
#  data           :json
#  server         :integer
#  twitch_user_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require "test_helper"

class TwitchStreamEventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
