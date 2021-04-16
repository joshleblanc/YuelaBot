# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  avatar_url :string
#  banned     :boolean          default(FALSE)
#  email      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  has_one :afk
  has_many :birthdays
  has_many :so_chat_cookies

  has_many :launch_alerts
  has_many :launch_alert_configs, through: :launch_alerts

  has_many :user_servers
  has_many :servers, through: :user_servers

  def self.login(auth_hash)
    user = User.where(id: auth_hash.uid).first_or_create
    user.sync_servers!(token: auth_hash["credentials"]["token"])
    user.update(
      name: auth_hash["info"].name,
      email: auth_hash["info"].email,
      avatar_url: auth_hash["info"].image
    )
    user
  end

  def sync_servers!(token:)
    response = Discordrb::API::User.servers("Bearer #{token}")
    json = JSON.parse(response.body)
    json.each do |record|
      server = Server.where(external_id: record["id"]).first_or_initialize
      server.assign_attributes(
        name: record["name"],
        icon: record["icon"]
      )
      server.save
      UserServer.where(server: server, user: self).first_or_create(owner: record["owner"])
    end
  end

  def afk?
    afk.present? && afk.persisted?
  end

  def afk!(message = "I'll be back")
    update(afk: Afk.create(message: message))
  end

  def back!
    afk.destroy if afk?
  end
end
