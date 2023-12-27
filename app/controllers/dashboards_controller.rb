class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_module_name,  :only => [:index]


  def attendance
    start_time = params[:start_time]
    end_time = params[:end_time]
    email = current_user.email

    employee  =  Employee.find_by(email: email)

    attendance_record = Attendance.find_by(employee_id: employee.id, date: Date.today.to_date)
    if attendance_record
      attendance_record.update!(end_time: end_time)
    else
      Attendance.create!(employee_id: employee.id, start_time: start_time, end_time: nil, date: Date.today.to_date)
    end
  end


  private
  def set_module_name
    @module_name = "dashboard"
    @icon_name = "bx bx-home-alt"
  end


end
