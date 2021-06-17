# == Schema Information
#
# Table name: crayta_users
#
#  id                 :bigint           not null, primary key
#  crayta_games_count :integer
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  external_id        :uuid
#
class CraytaUser < ApplicationRecord
  has_many :crayta_games
end
