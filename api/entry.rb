  require 'sinatra'

  get '/test' do
    p 'yeet'
  end

  Sinatra::Application.run!