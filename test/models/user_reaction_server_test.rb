# == Schema Information
#
# Table name: user_reaction_servers
#
#  id               :integer          not null, primary key
#  user_reaction_id :integer          not null
#  server_id        :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_user_reaction_servers_on_server_id         (server_id)
#  index_user_reaction_servers_on_user_reaction_id  (user_reaction_id)
#

require "test_helper"

class UserReactionServerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
