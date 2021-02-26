# == Schema Information
#
# Table name: game_keys
#
#  id         :bigint           not null, primary key
#  key        :string
#  name       :string
#  server     :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class GameKey < ApplicationRecord
end
