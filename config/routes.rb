Rails.application.routes.draw do
  resources :photos
  devise_for :users
  root "photos#index"
end
