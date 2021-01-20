Rails.application.routes.draw do
  namespace :webhooks do
    get :twitch, to: "webhooks/twitch#verify"
    post :twitch, to: "webhooks/twitch#receive"
  end 
end
