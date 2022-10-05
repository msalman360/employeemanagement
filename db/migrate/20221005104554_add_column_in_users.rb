class AddColumnInUsers < ActiveRecord::Migration[7.0]
  def change
    add_column  :users, :full_name, :string,  default: "System User"
    add_column  :users, :user_type, :string,  default: "user"
    add_column  :users, :is_active, :boolean, default: false
    add_column  :users, :is_role_assigned,  :boolean, default: false
  end
end
