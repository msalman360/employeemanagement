class AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_module_name, :only => [:index, :create, :show, :destroy]

  def index
    @attendance = Attendance.all
    ActivityStream.create_activity_stream("View Attendance Index Page", "Attendance", 0, @current_user, "view")
  end

  def show
    @attendance = Attendance.all
    if @attendance.present?
      ActivityStream.create_activity_stream("Filter Attendance", "Attendance", 0, @current_user, "filter")
      flash[:notice] = "Attendance Found Successfully"
    else
      flash[:alert] = "No Record Found"
    end
    render 'attendances/index'
  end

  def create
    attendance = Attendance.new(attendance_params)
    attendance.slug = params[:attendance_type].gsub(" ", "_").downcase
    if attendance.save
      ActivityStream.create_activity_stream("Create #{Attendance.last.attendance_type} New Attendance", "Attendance", Attendance.last.id, @current_user, "create")
      flash[:notice] = "Attendance Created Successfully"
    else
      if attendance.errors.full_messages.first == "Name has already been taken" or attendance.errors.full_messages.first == "Slug has already been taken"
        flash[:alert] = attendance.errors.full_messages.first.gsub("Slug", "Name")
      else
        flash[:alert] = "Something Went Wrong"
      end
    end
    redirect_to attendance_path
  end

  def update
    attendance = Attendance.find(params[:id])
    attendance.slug = params[:attendance_type].gsub(" ", "_").downcase
    if attendance.update(attendance_params)
      ActivityStream.create_activity_stream("Update #{attendance.attendance_type} Existing Employee", "Attendance", attendance.id, @current_user, "edit")
      flash[:notice] = "Attendance Updated Successfully"
    else
      if attendance.errors.full_messages.first == "Name has already been taken" or attendance.errors.full_messages.first == "Slug has already been taken"
        flash[:alert] = attendance.errors.full_messages.first
      else
        flash[:alert] = "Something Went Wrong"
      end
    end
    redirect_to employee_path
  end

  def destroy
    attendance = Attendance.find(params[:id])
    ActivityStream.create_activity_stream("Delete #{attendance.attendance_type} From Attendance", "Attendance", attendance.id, @current_user, "delete")
    attendance.delete
    flash[:notice] = "Attendance Deleted"
    redirect_to attendance_path
  end

  private

  def attendance_params
    params.permit(:attendance_type, :employee_id, :start_time, :end_time, :date,:slug)
  end

  def set_module_name
    @module_name = "dashboard"
    @sub_module_name = "attendance"
    @icon_name = "bx bx-cog"
  end
end
