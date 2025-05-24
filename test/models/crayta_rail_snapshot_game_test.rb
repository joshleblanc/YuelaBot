# == Schema Information
#
# Table name: crayta_rail_snapshot_games
#
#  id                      :integer          not null, primary key
#  crayta_rail_snapshot_id :integer          not null
#  crayta_game_id          :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_crayta_rail_snapshot_games_on_crayta_game_id           (crayta_game_id)
#  index_crayta_rail_snapshot_games_on_crayta_rail_snapshot_id  (crayta_rail_snapshot_id)
#

require "test_helper"

class CraytaRailSnapshotGameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
