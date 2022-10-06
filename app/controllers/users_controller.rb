class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_module_name,  :only => [:index, :create]

  def index
    @sub_module_name = "user"
    @users = User.all
  end

  def create
    user = User.new(user_params)
    if user.save
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

  private

  def user_params
    params.permit(:full_name, :email, :password, :is_active, :user_type)
  end
  def set_module_name
    @module_name = "system_settings"
    @icon_name = "bx bx-cog"
  end
end
