class CreateRoleColors < ActiveRecord::Migration[5.2]
  def change
    create_table :role_colors do |t|
      t.string :color
      t.string :name
      t.integer :server
      t.timestamps
    end
  end
end
