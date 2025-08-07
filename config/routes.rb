Rails.application.routes.draw do
  root "photos#index"
  devise_for :users
  resources :likes
  resources :follow_requests
  resources :comments
  resources :photos
  resources :users, only: :show
  get "/:username" => "users#show", as: :user
  
 
end
