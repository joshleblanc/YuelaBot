class User < ApplicationRecord
    has_one :afk
    has_many :birthdays
    has_many :so_chat_cookies

    has_many :launch_alerts
    has_many :launch_alert_configs, through: :launch_alerts

    def self.login(auth_hash)
        user = User.where(id: auth_hash.uid).first_or_create
        user.update(
            name: auth_hash["info"].name,
            email: auth_hash["info"].email,
            avatar_url: auth_hash["info"].image
        )
        user
    end
end