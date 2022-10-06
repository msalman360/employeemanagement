class AddColumnInMenu < ActiveRecord::Migration[7.0]
  def change
    add_column  :menus, :slug,  :string,  default: ""
  end
end
