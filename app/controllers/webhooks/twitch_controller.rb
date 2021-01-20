class Webhooks::TwitchController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:receive]

  def receive
    TwitchStreamEvent.create(server: params[:server], twitch_user_id: params[:user_id], data: params[:data])
  end

  def verify
    render plain: params["hub.challenge"]
  end
end
