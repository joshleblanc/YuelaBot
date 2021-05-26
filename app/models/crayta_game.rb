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
  # TODO: add the images array and videos array
  # TODO: Add crayta users
  # TODO: add names object?
  # TODO: add descriptions object?
  # TODO: add tags
end
