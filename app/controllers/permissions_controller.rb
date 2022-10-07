class PermissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_module_name,  :only => [:index, :create]

  def index
    @sub_module_name = "permission"
    @permissions = Permission.all
  end

  def create
    params[:menu_id].each_with_index do |menu_id, index|
      check_prev_permission = Permission.where(:user_id => params[:user_id].to_i, :menu_id => menu_id.to_i)
      menu = Menu.find(menu_id)
      if check_prev_permission.present?
        if menu.menu_type == "sub_menu"
          check_prev_permission.update(:is_index => params[:is_index][index], :is_create => params[:is_create][index], :in_view => params[:is_view][index], :is_edit => params[:is_edit][index], :is_delete => params[:is_delete][index])
        else
          check_prev_permission.update(:is_index => params[:is_index][index])
        end
      else
        if menu.menu_type == "sub_menu"
          permission = Permission.new
          permission.user_id = params[:user_id].to_i
          permission.menu_id = menu_id.to_i
          permission.is_index = params[:is_index][index]
          permission.is_create = params[:is_create][index]
          permission.is_view = params[:is_view][index]
          permission.is_edit = params[:is_edit][index]
          permission.is_delete = params[:is_delete][index]
          permission.save
        else
          permission = Permission.new
          permission.user_id = params[:user_id].to_i
          permission.menu_id = menu_id.to_i
          permission.is_index = params[:is_index][index]
          permission.save
        end
      end
    end
    User.find(params[:user_id]).update(:is_role_assigned => true)
    flash[:notice] = "Permission Updated"
    redirect_to permission_path
  end

  private

  def set_module_name
    @module_name = "system_settings"
    @icon_name = "bx bx-cog"
  end

end
