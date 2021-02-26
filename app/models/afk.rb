# == Schema Information
#
# Table name: afks
#
#  id         :bigint           not null, primary key
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_afks_on_user_id  (user_id)
#
class Afk < ApplicationRecord
    belongs_to :user
end
