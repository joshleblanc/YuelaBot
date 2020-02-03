class User < ApplicationRecord
    has_one :afk
    has_many :birthdays
    has_many :so_chat_cookies

    has_many :launch_alerts
    has_many :launch_alert_configs, through: :launch_alerts
end