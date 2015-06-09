Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "user/registrations", :omniauth_callbacks => "user/omniauth_callbacks" }
  
  root to: "users#index"

  resources :users, except: [:create, :new]

  resources :friendships, only: [:create, :destroy]
  
end
