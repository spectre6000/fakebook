Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "user/registrations" }
  
  root to: "users#index"

  resources :users, except: [:create, :new]
  
end
