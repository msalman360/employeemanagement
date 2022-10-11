class Dashboard < ApplicationRecord

  def self.check_side_bar_permission(menu_name, current_user)
    menu_id = Menu.where(:slug => menu_name).pluck(:id).uniq
    if menu_id.present?
      if current_user.role.permissions.where(:menu_id => menu_id).last.is_index == true
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def self.check_permission(menu_name, current_user, permission_type)
    menu_id = Menu.where(:slug => menu_name).pluck(:id).uniq
    if menu_id.present?
      if permission_type == "create"
        if current_user.role.permissions.where(:menu_id => menu_id).last.is_create == true
          return true
        else
          return false
        end
      elsif permission_type == "view"
        if current_user.role.permissions.where(:menu_id => menu_id).last.is_view == true
          return true
        else
          return false
        end
      elsif permission_type == "edit"
        if current_user.role.permissions.where(:menu_id => menu_id).last.is_edit == true
          return true
        else
          return false
        end
      elsif permission_type == "delete"
        if current_user.role.permissions.where(:menu_id => menu_id).last.is_delete == true
          return true
        else
          return false
        end
      end
    else
      return false
    end
  end

end
