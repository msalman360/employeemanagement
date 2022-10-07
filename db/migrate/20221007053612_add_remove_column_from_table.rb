class AddRemoveColumnFromTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :roles, :user_id, :integer
    remove_column :roles, :menu_id, :integer
    remove_column :roles, :is_edit, :integer
    remove_column :roles, :is_delete, :integer
    remove_column :roles, :is_create, :integer
    remove_column :roles, :is_index, :integer
    remove_column :roles, :is_view, :integer
    add_column  :roles, :name, :string
    remove_column :permissions, :user_id, :integer
    add_column  :permissions, :role_id, :integer
  end
end
