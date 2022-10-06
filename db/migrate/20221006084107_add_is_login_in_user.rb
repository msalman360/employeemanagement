class AddIsLoginInUser < ActiveRecord::Migration[7.0]
  def change
    add_column  :users, :is_logged_in,  :boolean, default: false
  end
end
