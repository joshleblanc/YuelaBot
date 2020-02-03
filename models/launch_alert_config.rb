class LaunchAlertConfig < ApplicationRecord
  has_many :launch_alerts
  has_many :users, through: :launch_alerts
end