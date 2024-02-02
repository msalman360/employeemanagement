class ApplicationController < ActionController::Base
  protect_from_forgery  with: :null_session
  helper_method :current_user, :authenticate_user!
  add_flash_types :success, :danger, :info, :warning
  require 'socket'

  private
  def authenticate_user!
    redirect_to root_path unless current_user
  end

  def current_user
    @current_user ||=
      begin
        return nil unless session[:user_id]

        User.find(session[:user_id])
      end
  end

  def save_excel_file(book, file_name)
    file_path = "/excel/#{file_name}.xlsx"
    book.serialize "#{Rails.public_path.to_s + file_path}"
    file_path
  end

  def check_directory(dir_path)
    unless File.directory?(dir_path)
      Dir.mkdir(dir_path)
    end
  end

end
