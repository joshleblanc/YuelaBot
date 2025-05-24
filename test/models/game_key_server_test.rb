# == Schema Information
#
# Table name: game_key_servers
#
#  id          :integer          not null, primary key
#  game_key_id :integer          not null
#  server_id   :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_game_key_servers_on_game_key_id  (game_key_id)
#  index_game_key_servers_on_server_id    (server_id)
#

require "test_helper"

class GameKeyServerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
