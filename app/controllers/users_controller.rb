class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_module_name,  :only => [:index]

  def index
    @sub_module_name = "user"
  end

  private

  def set_module_name
    @module_name = "system_settings"
    @icon_name = "bx bx-cog"
  end
end
