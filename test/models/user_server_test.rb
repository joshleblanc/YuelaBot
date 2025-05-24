# == Schema Information
#
# Table name: user_servers
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  server_id  :integer          not null
#  owner      :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_servers_on_server_id  (server_id)
#  index_user_servers_on_user_id    (user_id)
#

require "test_helper"

class UserServerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
