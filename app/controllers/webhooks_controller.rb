class WebhooksController < ApplicationController
  def twitch
    user_id = params[:user_id]
    server = params[:server]
  
    TwitchStreamEvent.create(data: params[:data], server: server, twitch_user_id: user_id)
  end
end
