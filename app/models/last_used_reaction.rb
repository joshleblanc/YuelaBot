# == Schema Information
#
# Table name: last_used_reactions
#
#  id               :bigint           not null, primary key
#  channel          :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_reaction_id :bigint
#
# Indexes
#
#  index_last_used_reactions_on_user_reaction_id  (user_reaction_id)
#
class LastUsedReaction < ApplicationRecord
  belongs_to :user_reaction 
end
