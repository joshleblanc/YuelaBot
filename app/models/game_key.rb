# == Schema Information
#
# Table name: game_keys
#
#  id         :bigint           not null, primary key
#  key        :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class GameKey < ApplicationRecord
  has_many :game_key_servers, dependent: :destroy
  has_many :servers, through: :game_key_servers

  scope :unclaimed, -> { where(claimed: false) }
  scope :claimed, -> { where(claimed: true) }

  validates_presence_of :name
  validates_presence_of :key
  validates_presence_of :servers

  def claim!
    update(claimed: true)
  end
end
