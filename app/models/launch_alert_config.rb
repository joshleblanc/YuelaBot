# == Schema Information
#
# Table name: launch_alert_configs
#
#  id         :bigint           not null, primary key
#  channel_id :string
#  server_id  :string
#
class LaunchAlertConfig < ApplicationRecord
  has_many :launch_alerts
  has_many :users, through: :launch_alerts
end
