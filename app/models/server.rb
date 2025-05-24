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

class Server < ApplicationRecord
  has_many :user_servers
  has_many :users, through: :user_servers

  has_many :game_key_servers
  has_many :game_keys, through: :game_key_servers
end
