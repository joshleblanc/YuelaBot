class LaunchAlert < ApplicationRecord
  belongs_to :user
  belongs_to :launch_alert_config
end