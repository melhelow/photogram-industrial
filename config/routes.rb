Rails.application.routes.draw do
  root "photos#index"
  devise_for :users
  
  resources :likes
  resources :follow_requests
  resources :comments
  resources :photos
  
  # Custom user routes - must come AFTER resources :photos
  get ":username" => "users#show", as: :user, constraints: { username: /[a-zA-Z0-9_]+/ }
  get ":username/liked" => "users#liked", as: :liked
  get ":username/feed" => "users#feed", as: :feed
  get ":username/discover" => "users#discover", as: :discover
  
  # Search route
  get "search" => "users#search", as: :search_users
end
