class CreateLastUserReactions < ActiveRecord::Migration[5.2]
  def change
    create_table :last_used_reactions do |t|
      t.belongs_to :user_reaction
      t.integer :channel, limit: 8
      t.timestamps
    end
  end
end
