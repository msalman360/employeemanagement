class DashboardsController < ApplicationController
  before_action :current_user
  def index
    if @current_user.present?
      render 'dashboards/index'
    else
      render 'dashboards/login'
    end
  end

end
