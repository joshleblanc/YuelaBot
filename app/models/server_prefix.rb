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
class ServerPrefix < ApplicationRecord
end
