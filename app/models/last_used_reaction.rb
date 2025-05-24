# == Schema Information
#
# Table name: last_used_reactions
#
#  id               :integer          not null, primary key
#  user_reaction_id :integer
#  channel          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_last_used_reactions_on_user_reaction_id  (user_reaction_id)
#

class LastUsedReaction < ApplicationRecord
  belongs_to :user_reaction 
end
