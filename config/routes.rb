Rails.application.routes.draw do
  get 'profile/edit'
  get 'profile/update'
  namespace :webhooks do
    get :twitch, to: "twitch#verify"
    post :twitch, to: "twitch#receive"
  end 
  
  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/sessions', to: "sessions#destroy"

  root to: "landing#index"
end
