# == Schema Information
#
# Table name: crayta_rail_snapshots
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  crayta_rail_id :bigint           not null
#
# Indexes
#
#  index_crayta_rail_snapshots_on_crayta_rail_id  (crayta_rail_id)
#
# Foreign Keys
#
#  fk_rails_...  (crayta_rail_id => crayta_rails.id)
#
class CraytaRailSnapshot < ApplicationRecord
  belongs_to :crayta_rail
  has_many :crayta_rail_snapshot_games
  has_many :crayta_games, through: :crayta_rail_snapshot_games
end
