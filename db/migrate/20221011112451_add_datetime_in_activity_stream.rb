class AddDatetimeInActivityStream < ActiveRecord::Migration[7.0]
  def change
    add_column  :activity_streams,  :action_date, :date
    add_column  :activity_streams,  :action_datetime, :datetime
  end
end
