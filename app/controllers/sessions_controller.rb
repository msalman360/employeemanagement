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
                ActivityStream.create_activity_stream("#{user.email} Logged-in To Dashboard", "User", @current_user.id, @current_user, "login")
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
                  ActivityStream.create_activity_stream("#{user.email} Logged-in To Dashboard", "User", @current_user.id, @current_user, "login")
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
      flash.now[:alert] = "Invalid Login Credentials."
      render 'sessions/login'
    end

  end

  def destroy
    user = User.find(session[:user_id])
    user.update(:is_logged_in => false)
    ActivityStream.create_activity_stream("#{user.email} Logout From Dashboard", "User", user.id, user, "logout")
    user.login_histories.where(:is_active => true).update(:is_active => false)
    session[:user_id] = nil
    flash[:notice] = "You have been logged out"
    render 'sessions/login'
  end

  def send_recover_email
    check_user = User.where(:email => params[:email])
    if check_user.present?
      if check_user.where(:is_active => true ).present?
        user = check_user.where(:email => params[:email])
        if user.present?
          if user.last.otp.present?
            flash[:alert] = "Already Sent Recovery E-mail."
          else
            otp = (0...3).map {(1..100).to_a[rand(100)]}.join
            user.update_all(:otp => otp.to_s)
            user_id = user.last.id
            NotificationsMailer.send_password_recover_email(params[:email], otp, user_id).deliver_now
            flash[:notice] = "Recovery E-mail Sent Successfully, Check Your Inbox or Spam."
          end
        else
          flash[:alert] = "E-mail Not Found In System."
        end
      else
        flash[:alert] = "Your Account Is Currently In-Active, Contact To Admin."
      end
    else
      flash[:alert] = "E-mail Not Found In System."
    end
    redirect_to recover_path
  end

  def reset_user_password
    user = User.find(params[:id])
    if user.present?
      if user.otp.present?
        if user.otp == params[:session][:otp]
          user.update(:password => params[:session][:password], :otp => nil)
          ActivityStream.create_activity_stream("Reset #{user.email} Password", "User", user.id, user, "edit")
          flash[:notice] = "Password Updated, You Can Login Now."
        else
          flash[:alert] = "OTP Not Matched, Enter Correct OTP"
        end
      else
        flash[:alert] = "OTP Not Found"
      end
    else
      flash[:alert] = "User Not Found"
    end
    redirect_to root_path
  end

end
