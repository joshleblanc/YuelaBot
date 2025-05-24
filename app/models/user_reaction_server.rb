# == Schema Information
#
# Table name: user_reaction_servers
#
#  id               :integer          not null, primary key
#  user_reaction_id :integer          not null
#  server_id        :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_user_reaction_servers_on_server_id         (server_id)
#  index_user_reaction_servers_on_user_reaction_id  (user_reaction_id)
#

class UserReactionServer < ApplicationRecord
  belongs_to :user_reaction
  belongs_to :server
end
