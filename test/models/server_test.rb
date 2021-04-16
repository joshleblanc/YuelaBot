# == Schema Information
#
# Table name: servers
#
#  id          :bigint           not null, primary key
#  icon        :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  external_id :bigint
#
require "test_helper"

class ServerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
