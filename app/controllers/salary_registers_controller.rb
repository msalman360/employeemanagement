class SalaryRegistersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_module_name, :only => [:index, :create, :show, :destroy]

  def index

  end

  def show
    start_date = params[:start_date]
    end_date = params[:end_date]
    @attendance = Attendance.where(date: start_date.to_date..end_date.to_date)
    if start_date.present? and end_date.present?
      if params[:export_file].to_s == "excel"
        pay_items = PayItem.where(pay_month: start_date.to_datetime..end_date.to_datetime, is_active: true).order('item_name ASC')
        time = Time.now
        book = Axlsx::Package.new
        check_directory("#{Rails.public_path}/excel")
        wb = book.workbook
        sheet = wb.add_worksheet(name: 'Salary Register')
        book.use_autowidth = false
        sheet.sheet_view do |view|
          view.show_outline_symbols = true
        end
        book.use_autowidth = true

        cell_style = sheet.styles.add_style :sz => 10, :alignment => { :horizontal => :center }, :font_name => 'Tahoma'
        sheet.add_row ["Extraction Date :", "#{DateTime.now.strftime("%d-%b-%Y %I:%M %P")}"], :style => cell_style
        sheet.add_row ['']
        sheet.add_row ['']
        sheet.add_row ['']
        sheet.add_row ['']

        bold_column_format = wb.styles.add_style(:bg_color => "E2C9F1", :fg_color => "000000", :sz => 8, :border => { :style => :thin, :color => "000000" }, :alignment => { :horizontal => :center, :vertical => :center }, :b => true)
        header_style = sheet.styles.add_style(:border => Axlsx::STYLE_THIN_BORDER, :bg_color => "c2c7c1", :sz => 10, :height => 15, :alignment => { :horizontal => :center }, :font_name => 'Tahoma', :b => true)
        header_style1 = sheet.styles.add_style(:border => Axlsx::STYLE_THIN_BORDER, :bg_color => "FFFF00", :sz => 10, :height => 15, :alignment => { :horizontal => :center }, :font_name => 'Tahoma', :b => true)
        header_style2 = sheet.styles.add_style(:border => Axlsx::STYLE_THIN_BORDER, :bg_color => "E2C9F1", :sz => 10, :height => 15, :alignment => { :horizontal => :center }, :font_name => 'Tahoma', :b => true)

        table_header = ["Sr #", "Employee Name", "Designation", "Hours", "Rate", "Total Earned", "Total Mileage"]

        pay_items.where.not(item_type: "Mileage").each do |pay_item|
          if pay_item.item_name
            table_header << pay_item.item_name
          end
        end
        table_header << "Total Earning"
        table_header << "Total Deduction"
        table_header << "Gross Pay"

        header_styles = table_header.map do |item|
          pay_item_earning = pay_items.where.not(item_type: "Mileage").find_by(item_name: item.to_s, payment_type: "Earning")
          style = pay_item_earning ? header_style1 : header_style

          pay_item_deduction = pay_items.where.not(item_type: "Mileage").find_by(item_name: item.to_s, payment_type: "Deduction")
          style = pay_item_deduction ? header_style2 : style

          style
        end



        sheet.add_row table_header, :style => header_styles
        old_row_format = wb.styles.add_style(:bg_color => "ffffff", :fg_color => "000000", :sz => 8, :border => { :style => :thin, :color => "000000" }, :alignment => { :horizontal => :center, :vertical => :center })
        even_row_format = wb.styles.add_style(:bg_color => "ffffff", :fg_color => "000000", :sz => 8, :border => { :style => :thin, :color => "000000" }, :alignment => { :horizontal => :center, :vertical => :center })
        count = 0
        @attendance.each do |pay_invoice|
          count = count + 1
          row_format = old_row_format

          if count.even? == true
            row_format = even_row_format
          else
            row_format = old_row_format
          end

          current_row_value = []
          current_row_style = []
          current_row_type = []

          current_row_value << count
          current_row_style << row_format
          current_row_type << :integer

          current_row_value << pay_invoice.employee.employee_name
          current_row_style << row_format
          current_row_type << :string

          current_row_value << pay_invoice.employee.designation_id
          current_row_style << row_format
          current_row_type << :string

          total_hours = ((pay_invoice.end_time.try(:-, pay_invoice.start_time) || 0) / 3600.0).to_f.round(2)
          hourly_salary = (pay_invoice.employee.salary * total_hours).round(2)

          current_row_value << total_hours
          current_row_style << row_format
          current_row_type << :float

          current_row_value << pay_invoice.employee.salary
          current_row_style << row_format
          current_row_type << :integer

          current_row_value << hourly_salary
          current_row_style << row_format
          current_row_type << :float

          current_row_value << pay_invoice.employee.pay_items.find_by(item_type: "Mileage").item_amount
          current_row_style << row_format
          current_row_type << :float

          pay_items.where.not(item_type: "Mileage").each do |item|
            current_row_value << item.item_amount
            current_row_style << row_format
            current_row_type << :float
          end

          total_earning = pay_invoice.employee.pay_items.where.not(item_type: "Mileage").where(payment_type: "Earning").sum(:item_amount).to_f.round(2)
          total_deduction = pay_invoice.employee.pay_items.where.not(item_type: "Mileage").where(payment_type: "Deduction").sum(:item_amount).to_f.round(2)

          current_row_value << total_earning + hourly_salary
          current_row_style << row_format
          current_row_type << :float

          current_row_value << total_deduction
          current_row_style << row_format
          current_row_type << :float

          current_row_value << (total_earning + hourly_salary) - total_deduction
          current_row_style << row_format
          current_row_type << :float

          sheet.add_row current_row_value, :style => current_row_style, :types => current_row_type
        end
        file_name = "salary_register"
        save_excel_file(book, file_name)
        @filename = "#{file_name}.xlsx"
        @filenames = "#{Rails.root}/public/excel/#{@filename}"
        send_file(@filenames, :type => 'application/pdf', :disposition => 'attachment')
      else
        render 'salary_registers/index'
      end
    end
  end

  private

  def set_module_name
    @module_name = "payroll_management"
    @sub_module_name = "salary_register"
    @icon_name = "fa fa-cash-register"
  end
end
