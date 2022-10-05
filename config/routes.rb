Rails.application.routes.draw do
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "sessions#login"

  ##### SESSIONS #####
  post 'create' => 'sessions#create'
  get 'logout' => 'sessions#destroy'
  get 'dashboard' => 'dashboards#index'
end
