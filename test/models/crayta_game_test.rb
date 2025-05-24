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

require "test_helper"

class CraytaGameTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
