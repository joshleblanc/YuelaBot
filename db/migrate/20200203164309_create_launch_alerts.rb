class CreateLaunchAlerts < ActiveRecord::Migration[5.2]
  def change
    create_table :launch_alerts do |t|
      t.belongs_to :launch_alert_config
      t.belongs_to :user
    end
  end
end
