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
class Server < ApplicationRecord
  has_many :user_servers
  has_many :users, through: :user_servers

  has_many :game_key_servers
  has_many :game_keys, through: :game_key_servers
end
