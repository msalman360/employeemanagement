class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_module_name,  :only => [:index]
  def index
  end

  private
  def set_module_name
    @module_name = "dashboard"
    @icon_name = "bx bx-home-alt"
  end
end
