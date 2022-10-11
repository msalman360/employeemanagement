class AddMainMenuIdInMenus < ActiveRecord::Migration[7.0]
  def change
    add_column  :menus, :main_menu_id,  :integer, default: nil
  end
end
