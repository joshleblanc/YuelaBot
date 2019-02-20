class CreateAfks < ActiveRecord::Migration[5.2]
  def change
    create_table :afks do |t|
      t.string :message, length: 250
      t.references :user
      t.timestamps
    end
  end
end
