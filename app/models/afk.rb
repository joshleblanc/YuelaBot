# == Schema Information
#
# Table name: afks
#
#  id         :integer          not null, primary key
#  message    :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_afks_on_user_id  (user_id)
#

class Afk < ApplicationRecord
    belongs_to :user
end
