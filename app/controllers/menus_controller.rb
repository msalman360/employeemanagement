class MenusController < ApplicationController
  before_action :authenticate_user!
  before_action :set_module_name,  :only => [:index, :create, :show, :destroy]

  def index
    @menus = Menu.all
    ActivityStream.create_activity_stream("View Menu Index Page", "Menus", 0, @current_user, "view")
  end

  def show
    if params[:is_active].present?
      params[:is_active] = true
    else
      params[:is_active] = false
    end
    @menus = Menu.where(:is_active => params[:is_active])
    if params[:menu_type].present?
      @menus = @menus.where(:menu_type => params[:menu_type])
    end
    if @menus.present?
      ActivityStream.create_activity_stream("Filter Menus", "Menu", 0, @current_user, "filter")
      flash[:notice] = "Menu Found Successfully"
    else
      flash[:alert] = "No Record Found"
    end
    render 'menus/index'
  end

  def create
    menu = Menu.new(menu_params)
    menu.slug = params[:name].gsub(" ", "_").downcase
    if menu.save
      Role.all.each do |role|
        Permission.create(:menu_id => Menu.last.id, :role_id => role.id)
      end
      ActivityStream.create_activity_stream("Create New Menu", "Menu", Menu.last.id, @current_user, "create")
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

  def update
    if params[:is_active].nil?
      params[:is_active] = false
    end
    menu = Menu.find(params[:id])
    menu.slug = params[:name].gsub(" ", "_").downcase
    if menu.update(menu_params)
      ActivityStream.create_activity_stream("Update Existing Menu", "Menu", menu.id, @current_user, "edit")
      flash[:notice] = "Menu Updated Successfully"
    else
      if menu.errors.full_messages.first == "Name has already been taken"
        flash[:alert] = menu.errors.full_messages.first
      else
        flash[:alert] = "Something Went Wrong"
      end
    end
    redirect_to menu_path
  end

  def destroy
    menu = Menu.find(params[:id])
    if menu.permissions.present?
      flash[:alert] = "Menu Has Currently Used In Permissions"
    else
      ActivityStream.create_activity_stream("Delete #{menu.name} From Menus", "Menu", menu.id, @current_user, "delete")
      menu.delete
      flash[:notice] = "Menu Deleted"
    end
    redirect_to menu_path
  end

  private

  def menu_params
    params.permit(:name, :is_active, :slug, :menu_type, :main_menu_id)
  end

  def set_module_name
    @module_name = "system_settings"
    @sub_module_name = "menus"
    @icon_name = "bx bx-cog"
  end
end
