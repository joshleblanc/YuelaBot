# == Schema Information
#
# Table name: crayta_rail_snapshots
#
#  id             :integer          not null, primary key
#  crayta_rail_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_crayta_rail_snapshots_on_crayta_rail_id  (crayta_rail_id)
#

class CraytaRailSnapshot < ApplicationRecord
  belongs_to :crayta_rail
  has_many :crayta_rail_snapshot_games
  has_many :crayta_games, through: :crayta_rail_snapshot_games
end
