class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_module_name,  :only => [:index, :create, :show, :destroy, :change_password]

  def index
    @users = User.all
    ActivityStream.create_activity_stream("View Users Index Page", "User", 0, @current_user, "view")
  end

  def show
    if params[:is_active].present?
      params[:is_active] = true
    else
      params[:is_active] = false
    end
    @users = User.where(:is_active => params[:is_active])
    if params[:user_type].present?
      @users = @users.where(:user_type => params[:user_type])
    end
    if params[:role_id].present?
      @users = @users.where(:role_id => params[:role_id])
    end
    if @users.present?
      ActivityStream.create_activity_stream("Filter Users", "User", 0, @current_user, "filter")
      flash[:notice] = "User Found Successfully"
    else
      flash[:alert] = "No Record Found"
    end
    render 'users/index'
  end

  def create
    user = User.new(user_params)
    if user.save
      ActivityStream.create_activity_stream("Create New User", "User", User.last.id, @current_user, "create")
      flash[:notice] = "User Created Successfully"
    else
      if user.errors.full_messages.first == "Email has already been taken"
        flash[:alert] = user.errors.full_messages.first
      else
        flash[:alert] = "Something Went Wrong"
      end
    end
    redirect_to user_path
  end

  def update
    if params[:is_active].nil?
      params[:is_active] = false
    end
    user = User.find(params[:id])
    if user.update(user_params)
      ActivityStream.create_activity_stream("Update Existing User", "User", user.id, @current_user, "edit")
      flash[:notice] = "User Updated Successfully"
    else
      flash[:alert] = "Something Went Wrong"
    end
    redirect_to user_path
  end

  def destroy
    user = User.find(params[:id])
    if user.login_histories.where(:is_active => true).present?
      flash[:alert] = "User Logged-In Somewhere"
    else
      ActivityStream.create_activity_stream("Delete #{user.email} From Users", "User", user.id, @current_user, "delete")
      user.login_histories.update_all(:is_active => false)
      user.activity_streams.delete_all
      ActivityStream.where(:user_id => nil).delete_all
      user.delete
      flash[:notice] = "User Deleted"
    end
    redirect_to user_path
  end

  def change_password
    user = User.find(params[:id])
    if user.authenticate(params[:old_password]).present?
      if params[:password].length > 7
        user.update(:password => params[:password])
        ActivityStream.create_activity_stream("Update #{user.email} Password", "User", user.id, @current_user, "edit")
        flash[:notice] = "Password Updated"
      else
        flash[:alert] = "Password Length Should Be Greater Then 8"
      end
    else
      flash[:alert] = "Kindly Enter Correct Password"
    end
    if params[:page].present?
      @id_name = "edit"
      render 'users/user_profile'
    else
      redirect_to user_path
    end
  end

  def user_profile
    @module_name = "user_profile"
    @activity_streams = current_user.activity_streams.where(:action_date => (Date.today - 1.days)..Date.today)
  end

  private

  def user_params
    params.permit(:full_name, :email, :password, :is_active, :user_type, :role_id)
  end
  def set_module_name
    @module_name = "system_settings"
    @sub_module_name = "users"
    @icon_name = "bx bx-cog"
  end
end
