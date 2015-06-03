Rails.application.routes.draw do
  devise_for :users
  
  root to: "user#index"

  resources :user
  
end
