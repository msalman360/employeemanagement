class ActivityStream < ApplicationRecord
  belongs_to  :user

  def self.create_activity_stream(action_name, table_name, table_id, current_user, slug)
    ip_address = current_user.login_histories.where(:is_active => true).last.ip_address
    browser_name = current_user.login_histories.where(:is_active => true).last.browser_name
    user_id = current_user.id
    ActivityStream.create(:action_name => action_name, :table_name => table_name, :table_id => table_id, :user_id => user_id, :ip_address => ip_address, :browser_name => browser_name, :action_date => Date.today, :action_datetime => Time.now, :slug => slug)
  end

end
