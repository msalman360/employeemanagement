class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_module_name, :only => [:index, :create, :show, :destroy]

  def index
    @employees = Employee.all
    ActivityStream.create_activity_stream("View Employee Index Page", "Employee", 0, @current_user, "view")
  end

  def show
    if params[:is_active].present?
      params[:is_active] = true
    else
      params[:is_active] = false
    end
    @employees = Employee.where(:is_active => params[:is_active])
    if @employees.present?
      ActivityStream.create_activity_stream("Filter Employee", "Employee", 0, @current_user, "filter")
      flash[:notice] = "employees Found Successfully"
    else
      flash[:alert] = "No Record Found"
    end
    render 'employees/index'
  end

  def create
    employees = Employee.new(employees_params)
    employees.slug = params[:employee_name].gsub(" ", "_").downcase
    if employees.save
      ActivityStream.create_activity_stream("Create #{Employee.last.employee_name} New Employee", "Employee", Employee.last.id, @current_user, "create")
      flash[:notice] = "Employee Created Successfully"
    else
      if employees.errors.full_messages.first == "Name has already been taken" or employees.errors.full_messages.first == "Slug has already been taken"
        flash[:alert] = employees.errors.full_messages.first.gsub("Slug", "Name")
      else
        flash[:alert] = "Something Went Wrong"
      end
    end
    redirect_to employee_path
  end

  def update
    if params[:is_active].nil?
      params[:is_active] = false
    end
    employees = Employee.find(params[:id])
    employees.slug = params[:employee_name].gsub(" ", "_").downcase
    if employees.update(employees_params)
      ActivityStream.create_activity_stream("Update #{employees.employee_name} Existing Employee", "Employee", employees.id, @current_user, "edit")
      flash[:notice] = "Menu Updated Successfully"
    else
      if employees.errors.full_messages.first == "Name has already been taken" or employees.errors.full_messages.first == "Slug has already been taken"
        flash[:alert] = employees.errors.full_messages.first
      else
        flash[:alert] = "Something Went Wrong"
      end
    end
    redirect_to employee_path
  end

  def destroy
    employees = Employee.find(params[:id])
    ActivityStream.create_activity_stream("Delete #{employees.employee_name} From Menus", "Menu", employees.id, @current_user, "delete")
    employees.delete
    flash[:notice] = "Employee Deleted"
    redirect_to employee_path
  end

  private

  def employees_params
    params.permit(:employee_name, :department_id, :roster_id,:designation_id,:email, :gender, :is_hod, :phone_number ,:is_active, :slug)
  end

  def set_module_name
    @module_name = "system_settings"
    @sub_module_name = "employees"
    @icon_name = "bx bx-cog"
  end
end
