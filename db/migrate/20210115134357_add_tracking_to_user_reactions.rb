class AddTrackingToUserReactions < ActiveRecord::Migration[5.2]
  def change
    add_column :user_reactions, :last_used_at, :datetime
    add_column :user_reactions, :first_used_at, :datetime
    add_column :user_reactions, :times_used, :integer, default: 0
  end
end
