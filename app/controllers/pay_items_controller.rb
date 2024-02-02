class PayItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_module_name, :only => [:index, :create, :show, :destroy]

  def index
    @pay_item = PayItem.all
    ActivityStream.create_activity_stream("View PayItem Index Page", "PayItem", 0, @current_user, "view")
  end

  def show
    @pay_item = PayItem.all
    if @pay_item.present?
      ActivityStream.create_activity_stream("Filter PayItem", "PayItem", 0, @current_user, "filter")
      flash[:notice] = "PayItem Found Successfully"
    else
      flash[:alert] = "No Record Found"
    end
    render 'pay_items/index'
  end

  def create
    pay_item = PayItem.new(pay_item_params)
    pay_item.slug = params[:item_name].gsub(" ", "_").downcase
    if params[:pay_month].present?
        pay_item.pay_month = Date.strptime(params[:pay_month], "%Y-%m")
        pay_item.formatted_pay_month = pay_item.pay_month.strftime("%B %Y")
    else
      pay_item.pay_month = nil
      pay_item.formatted_pay_month = nil
    end

    if pay_item.save
      ActivityStream.create_activity_stream("Create #{PayItem.last.item_name} New PayItem", "PayItem", PayItem.last.id, @current_user, "create")
      flash[:notice] = "PayItem Created Successfully"
    else
      if pay_item.errors.full_messages.first == "Name has already been taken" or pay_item.errors.full_messages.first == "Slug has already been taken"
        flash[:alert] = pay_item.errors.full_messages.first.gsub("Slug", "Name")
      else
        flash[:alert] = "Something Went Wrong"
      end
    end
    redirect_to pay_item_path
  end

  def update
    pay_item = PayItem.find(params[:id])
    pay_item.slug = params[:item_name].gsub(" ", "_").downcase
    if pay_item.update(pay_item_params)
      ActivityStream.create_activity_stream("Update #{pay_item.item_name} Existing PayItem", "PayItem", pay_item.id, @current_user, "edit")
      flash[:notice] = "PayItem Updated Successfully"
    else
      if pay_item.errors.full_messages.first == "Name has already been taken" or pay_item.errors.full_messages.first == "Slug has already been taken"
        flash[:alert] = pay_item.errors.full_messages.first
      else
        flash[:alert] = "Something Went Wrong"
      end
    end
    redirect_to employee_path
  end

  def destroy
    pay_item = PayItem.find(params[:id])
    ActivityStream.create_activity_stream("Delete #{pay_item.item_name} From PayItem", "PayItem", pay_item.id, @current_user, "delete")
    pay_item.delete
    flash[:notice] = "PayItem Deleted"
    redirect_to pay_item_path
  end

  private

  def pay_item_params
    params.permit(:company_id, :employee_id, :item_name, :item_amount, :is_active, :payment_type, :item_type,:start_date,:end_date, :description)
  end

  def set_module_name
    @module_name = "payroll_management"
    @sub_module_name = "pay_item"
    @icon_name = "bx bx-cog"
  end
end
