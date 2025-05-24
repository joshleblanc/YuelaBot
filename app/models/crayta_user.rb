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

class CraytaUser < ApplicationRecord
  has_many :crayta_games
end
