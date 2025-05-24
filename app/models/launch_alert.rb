# == Schema Information
#
# Table name: launch_alerts
#
#  id                     :integer          not null, primary key
#  launch_alert_config_id :integer
#  user_id                :integer
#
# Indexes
#
#  index_launch_alerts_on_launch_alert_config_id  (launch_alert_config_id)
#  index_launch_alerts_on_user_id                 (user_id)
#

class LaunchAlert < ApplicationRecord
  belongs_to :user
  belongs_to :launch_alert_config
end
