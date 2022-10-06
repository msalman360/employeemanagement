Rails.application.routes.draw do
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "sessions#login"

  ##### SESSIONS #####
  post 'create' => 'sessions#create'
  get 'logout' => 'sessions#destroy'

  ##### DASHBOARDS #####
  get 'dashboard' => 'dashboards#index'

  ##### USERS #####
  get 'user' => 'users#index'
  post 'new_user' => 'users#create'

  ##### MENUS #####
  get 'menu' => 'menus#index'
  post 'new_menu' => 'menus#create'

  ##### PERMISSIONS #####
  get 'permission' => 'permissions#index'
  post 'new_permission' => 'permissions#create'

end
