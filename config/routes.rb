Rails.application.routes.draw do
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "sessions#login"

  ##### SESSIONS #####
  post 'create' => 'sessions#create'
  post 'reset_user_password' => 'sessions#reset_user_password'
  get 'logout' => 'sessions#destroy'
  get 'recover' => 'sessions#recover'
  post 'send_recover' => 'sessions#send_recover_email'
  get 'reset_password' => 'sessions#reset_password'

  ##### DASHBOARDS #####
  get 'dashboard' => 'dashboards#index'
  post 'attendance' => 'dashboards#attendance'

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
  get 'user_profile' => 'users#user_profile'

  ##### STATUSES #####
  get 'status' => 'statuses#index'
  post 'new_status' => 'statuses#create'
  post 'update_status' => 'statuses#update'
  post 'delete_status' => 'statuses#destroy'
  post 'filter_status' => 'statuses#show'

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


  ##### Employees #####
  get 'employee' => 'employees#index'
  post 'new_employee' => 'employees#create'
  post 'update_employee' => 'employees#update'
  post 'delete_employee' => 'employees#destroy'
  post 'filter_employee' => 'employees#show'


  ##### Attendance #####
  get 'attendance' => 'attendances#index'
  post 'new_attendance' => 'attendances#create'
  post 'update_attendance' => 'attendances#update'
  post 'delete_attendance' => 'attendances#destroy'
  post 'filter_attendance' => 'attendances#show'


  ##### Attendance #####
  get 'roster' => 'rosters#index'
  post 'new_roster' => 'rosters#create'
  post 'update_roster' => 'rosters#update'
  post 'delete_roster' => 'rosters#destroy'
  post 'filter_roster' => 'rosters#show'

end
