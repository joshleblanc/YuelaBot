Rails.application.routes.draw do
  namespace :webhooks do
    get :twitch, to: "twitch#verify"
    post :twitch, to: "twitch#receive"
  end 
end
