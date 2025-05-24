# == Schema Information
#
# Table name: crayta_users
#
#  id                 :integer          not null, primary key
#  name               :string
#  external_id        :uuid
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  crayta_games_count :integer
#

require "test_helper"

class CraytaUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
