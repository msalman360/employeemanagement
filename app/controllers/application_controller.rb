class ApplicationController < ActionController::Base
  protect_from_forgery  with: :null_session
  helper_method :current_user, :authenticate_user!
  add_flash_types :success, :danger, :info, :warning
  require 'socket'

  private
  def authenticate_user!
    redirect_to root_path unless current_user
  end

  def current_user
    @current_user ||=
      begin
        return nil unless session[:user_id]

        User.find(session[:user_id])
      end
  end

end
