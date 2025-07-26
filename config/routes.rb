Rails.application.routes.draw do
  resources :follow_requests
  resources :comments
  resources :photos
  devise_for :users
  root "photos#index"
end
