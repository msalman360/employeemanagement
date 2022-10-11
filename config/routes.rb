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

  ##### ACTIVITY STREAMS #####
  get 'activity_stream' => 'activity_streams#index'
  post 'filter_activity_stream' => 'activity_streams#show'

  ##### USERS #####
  get 'user' => 'users#index'
  post 'new_user' => 'users#create'
  post 'update_user' => 'users#update'
  post 'delete_user' => 'users#destroy'
  post 'change_password_user' => 'users#change_password'
  post 'filter_user' => 'users#show'

  ##### MENUS #####
  get 'menu' => 'menus#index'
  post 'new_menu' => 'menus#create'
  post 'update_menu' => 'menus#update'
  post 'delete_menu' => 'menus#destroy'
  post 'filter_menu' => 'menus#show'

  ##### ROLE/PERMISSIONS #####
  get 'role' => 'roles#index'
  post 'new_role' => 'roles#create'
  post 'update_role' => 'roles#update'
  post 'delete_role' => 'roles#destroy'
  post 'filter_role' => 'roles#show'

end
