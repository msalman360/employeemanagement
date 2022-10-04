class SessionsController < ApplicationController

  def create
    user = User.find_by(:email => params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      @current_user = user
      if @current_user.present?
        flash[:notice] = "Logged in Successfully"
        render 'dashboards/index'
      end
    else
      flash[:alert] = "Incorrect Username or Password"
      render 'dashboards/login'
    end
  end

  def login
    if session[:user_id].present?
      render 'dashboards/index'
    else
      render 'dashboards/login'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have been logged out"
    render 'dashboards/login'
  end

end
