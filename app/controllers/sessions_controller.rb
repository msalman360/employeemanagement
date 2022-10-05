class SessionsController < ApplicationController

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      @current_user = user
      if @current_user.present?
        flash[:notice] = "Logged in successfully."
        render 'dashboards/index'
      end
    else
      flash.now[:alert] = "There was something wrong with your login details."
      render 'sessions/login'
    end
  end

  # def login
  #   if session[:user_id].present?
  #     render 'dashboards/index'
  #   else
  #     render 'dashboards/login'
  #   end
  # end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have been logged out"
    render 'sessions/login'
  end

end
