class WebhooksController < ApplicationController
  def twitch
    user_id = params[:user_id]
    server = params[:server]
  
    twitch_configs = TwitchConfig.where(server: server)
    
    params[:data].each do |datum|
      embed = Discordrb::Webhooks::Embed.new
      case datum["type"]
      when "live"
        embed.title "#{datum["user_name"]} is now live on Twitch!"
      end
      twitch_configs.each do |config|
        BOT.send_message(config.channel, nil, nil, embed)
      end
    end
  end
end
