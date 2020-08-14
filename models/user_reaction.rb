class UserReaction < ApplicationRecord
    has_many :last_used_reactions
end