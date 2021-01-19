require 'sinatra/base'

class SinatraServer < Sinatra::Application
  get '/reactions' do
    @reactions = UserReaction.all
    haml :"reactions/index"
  end
  
  post "/webhooks/twitch" do
    user_id = params[:user_id]
    server = params[:server]
    body = JSON.parse(request.body)
  
    twitch_configs = TwitchConfig.where(server: server)
    
    body["data"].each do |datum|
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