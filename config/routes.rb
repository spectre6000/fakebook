Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "user/registrations", :omniauth_callbacks => "user/omniauth_callbacks" }
  
  root to: "users#index"

  resources :users, except: [:create, :new]

  # devise_scope :user do
  #   get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  # end
  
end
