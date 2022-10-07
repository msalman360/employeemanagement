class AddRoleIdInUsers < ActiveRecord::Migration[7.0]
  def change
    add_column  :users, :role_id, :integer
    remove_column :users, :is_role_assigned,  :boolean
  end
end
