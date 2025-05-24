# == Schema Information
#
# Table name: server_prefixes
#
#  id         :integer          not null, primary key
#  server     :integer
#  prefix     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ServerPrefix < ApplicationRecord
end
