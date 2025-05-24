# == Schema Information
#
# Table name: crayta_games
#
#  id                  :integer          not null, primary key
#  external_id         :uuid
#  name                :string
#  description         :string
#  external_created_at :datetime
#  external_updated_at :datetime
#  published           :boolean
#  hidden              :boolean
#  publically_editable :boolean
#  system_game         :boolean
#  copyable            :boolean
#  concealed           :boolean
#  archived            :boolean
#  cover_image         :uuid
#  up_votes            :integer
#  down_votes          :integer
#  visits              :integer
#  max_players         :integer
#  state_share_url     :string
#  blocked             :boolean
#  game_link           :string
#  binned              :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  crayta_user_id      :integer          not null
#
# Indexes
#
#  index_crayta_games_on_crayta_user_id  (crayta_user_id)
#

class CraytaGame < ApplicationRecord
  has_paper_trail

  belongs_to :crayta_user, counter_cache: true
  has_many :crayta_rail_snapshot_games
  has_many :crayta_rail_snapshots, through: :crayta_rail_snapshot_games
  # TODO: add the images array and videos array
  # TODO: Add crayta users
  # TODO: add names object?
  # TODO: add descriptions object?
  # TODO: add tags

  def external_url
    "https://play.crayta.com/games/#{external_id}"
  end

  def cover_url
    "https://live.content.crayta.com/game/#{external_id}/#{cover_image}_cover"
  end

  def rank 
    CraytaGame.order(visits: :desc).pluck(:id).index(id)&.next
  end

  def times_in_rails
    rails = crayta_rail_snapshots.eager_load(:crayta_rail).order(:created_at).group_by { |a| a.crayta_rail.name }
    rails.map do |name, snapshots|
      dates = []
      current_interval = []
      dates << current_interval
      snapshots.each do |snapshot|
        if current_interval.empty?
          current_interval << snapshot.created_at
        else
          diff = ((snapshot.created_at - current_interval.last) / 100).round
          if diff == 6 then
            current_interval[1] = snapshot.created_at
          else
            current_interval = [snapshot.created_at]
            dates << current_interval
          end
        end
      end
      dates.map do |date_arr|
        [name, *date_arr]
      end.reject { |a| a.compact.length < 3 }
    end.flatten(1)
  end
end
