# == Schema Information
#
# Table name: launch_alert_configs
#
#  id         :integer          not null, primary key
#  server_id  :string
#  channel_id :string
#

class LaunchAlertConfig < ApplicationRecord
  has_many :launch_alerts
  has_many :users, through: :launch_alerts
end
