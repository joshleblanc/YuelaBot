  require 'sinatra'

  get '/reactions' do
    @reactions = UserReaction.all
    haml :"reactions/index"
  end

  Sinatra::Application.run!