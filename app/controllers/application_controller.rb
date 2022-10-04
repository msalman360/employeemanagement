class ApplicationController < ActionController::Base
  protect_from_forgery  with: :null_session
  helper_method :current_user
  add_flash_types :success, :danger, :info, :warning

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

end
