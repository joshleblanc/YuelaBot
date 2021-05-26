# == Schema Information
#
# Table name: crayta_rail_snapshot_games
#
#  id                      :bigint           not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  crayta_game_id          :bigint           not null
#  crayta_rail_snapshot_id :bigint           not null
#
# Indexes
#
#  index_crayta_rail_snapshot_games_on_crayta_game_id           (crayta_game_id)
#  index_crayta_rail_snapshot_games_on_crayta_rail_snapshot_id  (crayta_rail_snapshot_id)
#
# Foreign Keys
#
#  fk_rails_...  (crayta_game_id => crayta_games.id)
#  fk_rails_...  (crayta_rail_snapshot_id => crayta_rail_snapshots.id)
#
require "test_helper"

class CraytaRailSnapshotGameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
