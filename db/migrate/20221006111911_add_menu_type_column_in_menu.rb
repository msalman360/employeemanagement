class AddMenuTypeColumnInMenu < ActiveRecord::Migration[7.0]
  def change
    add_column  :menus, :menu_type, :string,  default: ""
  end
end
