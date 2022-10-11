class SessionsController < ApplicationController

  def create
    ip_address = request.remote_addr
    browser_name = request.user_agent
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.is_active == true
        if user.role.present?
          if user.role.is_active == true
            if user.login_histories.where(:is_active => true, :browser_name => browser_name, :ip_address => ip_address).present?
              user.update(:is_logged_in => true)
              session[:user_id] = user.id
              @current_user = user
              if @current_user.present?
                flash[:notice] = "Logged in successfully."
                @module_name = "dashboard"
                @icon_name = "bx bx-home-alt"
                render 'dashboards/index'
              end
            else
              if user.is_logged_in == false
                user.update(:is_logged_in => true)
                session[:user_id] = user.id
                @current_user = user
                if @current_user.present?
                  LoginHistory.create(:user_id => @current_user.id, :ip_address => ip_address, :browser_name => browser_name, :is_active => true)
                  flash[:notice] = "Logged in successfully."
                  @module_name = "dashboard"
                  @icon_name = "bx bx-home-alt"
                  render 'dashboards/index'
                end
              else
                flash.now[:alert] = "Already logged-in on some other device."
                render 'sessions/login'
              end
            end
          else
            flash.now[:alert] = "Your Role/Permission Is In-Active, Contact To Admin"
            render 'sessions/login'
          end
        else
          flash.now[:alert] = "No Role/Permission Assigned, Contact To Admin"
          render 'sessions/login'
        end
      else
        flash[:alert] = "Account Is Currently In-Active, Contact To Admin"
        render 'sessions/login'
      end
    else
      flash.now[:alert] = "There was something wrong with your login details."
      render 'sessions/login'
    end

  end

  def destroy
    user = User.find(session[:user_id])
    user.update(:is_logged_in => false)
    user.login_histories.where(:is_active => true).update(:is_active => false)
    session[:user_id] = nil
    flash[:notice] = "You have been logged out"
    render 'sessions/login'
  end

end
