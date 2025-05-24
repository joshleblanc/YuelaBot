# == Schema Information
#
# Table name: servers
#
#  id          :integer          not null, primary key
#  external_id :integer
#  name        :string
#  icon        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "test_helper"

class ServerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
