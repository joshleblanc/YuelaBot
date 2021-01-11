class AddServerToUserReaction < ActiveRecord::Migration[5.2]
  def change
    add_column :user_reactions, :server, :integer, limit: 8

    sql = <<~SQL
      update user_reactions set server = 412309229878378498
    SQL

    execute sql
  end
end
