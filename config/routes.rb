# config/routes.rb
Rails.application.routes.draw do
  root "users#feed"

  devise_for :users

  resources :likes
  resources :follow_requests
  resources :comments
  resources :photos
  resources :users, only: [:index]

  # These custom routes must be LAST
  get ":username" => "users#show", as: :user
  get ":username/liked" => "users#liked", as: :liked
  get ":username/feed" => "users#feed", as: :feed
  get ":username/discover" => "users#discover", as: :discover
end
