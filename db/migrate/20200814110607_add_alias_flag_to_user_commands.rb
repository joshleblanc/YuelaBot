class AddAliasFlagToUserCommands < ActiveRecord::Migration[5.2]
  def change
    add_column :user_commands, :alias, :boolean, default: false
  end
end
