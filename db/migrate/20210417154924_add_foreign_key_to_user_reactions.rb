class AddForeignKeyToUserReactions < ActiveRecord::Migration[6.1]
  def change
    add_reference :user_reactions, :user, null: true
  end
end
