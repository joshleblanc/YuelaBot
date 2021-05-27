# == Schema Information
#
# Table name: crayta_games
#
#  id                  :bigint           not null, primary key
#  archived            :boolean
#  binned              :boolean
#  blocked             :boolean
#  concealed           :boolean
#  copyable            :boolean
#  cover_image         :uuid
#  description         :string
#  down_votes          :integer
#  external_created_at :datetime
#  external_updated_at :datetime
#  game_link           :string
#  hidden              :boolean
#  max_players         :integer
#  name                :string
#  publically_editable :boolean
#  published           :boolean
#  state_share_url     :string
#  system_game         :boolean
#  up_votes            :integer
#  visits              :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  crayta_user_id      :bigint           not null
#  external_id         :uuid
#
# Indexes
#
#  index_crayta_games_on_crayta_user_id  (crayta_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (crayta_user_id => crayta_users.id)
#
class CraytaGame < ApplicationRecord
  belongs_to :crayta_user
  has_many :crayta_rail_snapshot_games
  has_many :crayta_rail_snapshots, through: :crayta_rail_snapshot_games
  # TODO: add the images array and videos array
  # TODO: Add crayta users
  # TODO: add names object?
  # TODO: add descriptions object?
  # TODO: add tags

  def times_in_rails

    rails = crayta_rail_snapshots.order(:created_at).group_by { |a| a.crayta_rail.name }
    rails.map do |name, snapshots|
      snapshots.each_cons(2).map do |snapshots|
        first, second = snapshots
        [name, first.created_at, second.created_at]
      end.reject { |a| a.compact.length < 3 }.flatten
    end
  end
end
