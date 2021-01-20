class Webhooks::TwitchController < ApplicationController
  def receive
    TwitchStreamEvent.create(server: params[:server], twitch_user_id: params[:user_id], data: params[:data])
  end

  def verify
    render plain: params["hub.challenge"]
  end
end
