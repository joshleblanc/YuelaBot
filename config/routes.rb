Rails.application.routes.draw do
  namespace :crayta do
    get 'games' => "games#index", as: :games
    get 'games/:id' => "games#show", as: :game
    get 'games/:id/timeline' => "games#timeline", as: :game_timeline
    get 'users/:id/games' => "users#games", as: :user_games
    get 'users' => "users#index"
  end
  resources :user_reactions
  resources :game_keys
  resources :afks, only: [:edit, :destroy, :new, :create]
  patch 'current_user/toggle_afk'
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
