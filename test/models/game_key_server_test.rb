# == Schema Information
#
# Table name: game_key_servers
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  game_key_id :bigint           not null
#  server_id   :bigint           not null
#
# Indexes
#
#  index_game_key_servers_on_game_key_id  (game_key_id)
#  index_game_key_servers_on_server_id    (server_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_key_id => game_keys.id)
#  fk_rails_...  (server_id => servers.id)
#
require "test_helper"

class GameKeyServerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
