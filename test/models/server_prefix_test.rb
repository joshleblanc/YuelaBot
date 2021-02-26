# == Schema Information
#
# Table name: server_prefixes
#
#  id         :bigint           not null, primary key
#  prefix     :string
#  server     :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class ServerPrefixTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
