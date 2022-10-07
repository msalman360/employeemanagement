class MenusController < ApplicationController
  before_action :authenticate_user!
  before_action :set_module_name,  :only => [:index, :create]

  def index
    @sub_module_name = "menu"
    @menus = Menu.all
  end

  def create
    menu = Menu.new(menu_params)
    menu.slug = params[:name].gsub(" ", "_").downcase
    if menu.save
      Role.all.each do |role|
        Permission.create(:menu_id => Menu.last.id, :role_id => role.id)
      end
      flash[:notice] = "User Created Successfully"
    else
      if menu.errors.full_messages.first == "Name has already been taken"
        flash[:alert] = menu.errors.full_messages.first
      else
        flash[:alert] = "Something Went Wrong"
      end
    end
    redirect_to menu_path
  end

  private

  def menu_params
    params.permit(:name, :is_active, :slug, :menu_type)
  end

  def set_module_name
    @module_name = "system_settings"
    @icon_name = "bx bx-cog"
  end
end
