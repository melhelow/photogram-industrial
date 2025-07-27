Rails.application.routes.draw do
  root "photos#index"
  devise_for :users
  resources :likes
  resources :follow_requests
  resources :comments
  resources :photos
  
 
end
