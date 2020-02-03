class CreateLaunchAlertConfig < ActiveRecord::Migration[5.2]
  def change
    create_table :launch_alert_configs do |t|
      t.string :server_id
      t.string :channel_id
    end
  end
end
