class RostersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_module_name,  :only => [:index, :create, :show, :destroy]

  def index
    @roster = Roster.all
    ActivityStream.create_activity_stream("View Roster Index Page", "Roster", 0, @current_user, "view")
  end

  def show
    if params[:is_active].present?
      params[:is_active] = true
    else
      params[:is_active] = false
    end
    @roster = Roster.where(:is_active => params[:is_active])
    if @roster.present?
      ActivityStream.create_activity_stream("Filter Roster", "Roster", 0, @current_user, "filter")
      flash[:notice] = "Roster Found Successfully"
    else
      flash[:alert] = "No Record Found"
    end
    render 'rosters/index'
  end

  def create
    roster = Roster.new(roster_params)
    roster.slug = params[:name].gsub(" ", "_").downcase
    if roster.save
      ActivityStream.create_activity_stream("Create #{Roster.last.name} New Roster", "Roster", Roster.last.id, @current_user, "create")
      flash[:notice] = "Roster Created Successfully"
    else
      if roster.errors.full_messages.first == "Name has already been taken" or roster.errors.full_messages.first == "Slug has already been taken"
        flash[:alert] = roster.errors.full_messages.first.gsub("Slug", "Name")
      else
        flash[:alert] = "Something Went Wrong"
      end
    end
    redirect_to roster_path
  end

  def update
    if params[:is_active].nil?
      params[:is_active] = false
    end
    roster = Roster.find(params[:id])
    roster.slug = params[:name].gsub(" ", "_").downcase
    if roster.update(roster_params)
      ActivityStream.create_activity_stream("Update #{roster.name} Existing Roster", "Roster", roster.id, @current_user, "edit")
      flash[:notice] = "Menu Updated Successfully"
    else
      if roster.errors.full_messages.first == "Name has already been taken" or roster.errors.full_messages.first == "Slug has already been taken"
        flash[:alert] = roster.errors.full_messages.first
      else
        flash[:alert] = "Something Went Wrong"
      end
    end
    redirect_to roster_path
  end

  def destroy
    roster = Roster.find(params[:id])
    ActivityStream.create_activity_stream("Delete #{roster.name} From Roster", "Menu", roster.id, @current_user, "delete")
    roster.delete
    flash[:notice] = "Roster Deleted"
    redirect_to roster_path
  end

  private

  def roster_params
    params.permit(:name, :client,:shift_type,:is_active, :slug)
  end

  def set_module_name
    @module_name = "system_settings"
    @sub_module_name = "shift"
    @icon_name = "bx bx-cog"
  end


end
