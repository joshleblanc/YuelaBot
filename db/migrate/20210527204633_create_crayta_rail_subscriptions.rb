class CreateCraytaRailSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :crayta_rail_subscriptions do |t|
      t.bigint :channel

      t.timestamps
    end
  end
end
