class AddClaimedToGameKey < ActiveRecord::Migration[6.1]
  def change
    add_column :game_keys, :claimed, :boolean, default: false
  end
end
