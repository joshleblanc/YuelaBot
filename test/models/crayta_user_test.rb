# == Schema Information
#
# Table name: crayta_users
#
#  id          :bigint           not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  external_id :uuid
#
require "test_helper"

class CraytaUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
