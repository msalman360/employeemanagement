class StatusesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_module_name,  :only => [:index, :create, :show, :destroy]

  def index
    @statuses = Status.all
    ActivityStream.create_activity_stream("View Status Index Page", "Status", 0, @current_user, "view")
  end

  def show
    if params[:is_active].present?
      params[:is_active] = true
    else
      params[:is_active] = false
    end
    @statuses = Status.where(:is_active => params[:is_active])
    if @statuses.present?
      ActivityStream.create_activity_stream("Filter Statuses", "Status", 0, @current_user, "filter")
      flash[:notice] = "Status Found Successfully"
    else
      flash[:alert] = "No Record Found"
    end
    render 'statuses/index'
  end

  def create
    status = Status.new(status_params)
    status.slug = params[:name].gsub(" ", "_").downcase
    if status.save
      ActivityStream.create_activity_stream("Create New Status", "Status", Status.last.id, @current_user, "create")
      flash[:notice] = "Status Created Successfully"
    else
      if status.errors.full_messages.first == "Name has already been taken" or status.errors.full_messages.first == "Slug has already been taken"
        flash[:alert] = status.errors.full_messages.first
      else
        flash[:alert] = "Something Went Wrong"
      end
    end
    redirect_to status_path
  end

  def update
    if params[:is_active].nil?
      params[:is_active] = false
    end
    status = Status.find(params[:id])
    status.slug = params[:name].gsub(" ", "_").downcase
    if status.update(status_params)
      ActivityStream.create_activity_stream("Update Existing Status", "Status", status.id, @current_user, "edit")
      flash[:notice] = "Menu Updated Successfully"
    else
      if status.errors.full_messages.first == "Name has already been taken" or status.errors.full_messages.first == "Slug has already been taken"
        flash[:alert] = status.errors.full_messages.first
      else
        flash[:alert] = "Something Went Wrong"
      end
    end
    redirect_to status_path
  end

  def destroy
    status = Status.find(params[:id])
    ActivityStream.create_activity_stream("Delete #{status.name} From Menus", "Menu", status.id, @current_user, "delete")
    status.delete
    flash[:notice] = "Status Deleted"
    redirect_to status_path
  end

  private

  def status_params
    params.permit(:name, :is_active, :slug)
  end

  def set_module_name
    @module_name = "system_settings"
    @sub_module_name = "statuses"
    @icon_name = "bx bx-cog"
  end

end
