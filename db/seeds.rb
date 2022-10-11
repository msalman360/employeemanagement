# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
["dashboard", "system_settings", "users", "menus", "roles", "locations", "categories", "activity_streams"].each do |menu_name|
  check_menu = Menu.where(:slug => menu_name)
  if not check_menu.present?
    if menu_name == "dashboard" or menu_name == "system_settings" or menu_name == "activity_streams"
      Menu.create(:name => menu_name.gsub("_", " ").capitalize, :menu_type => "main_menu", :is_active => true, :slug => menu_name)
    else
      Menu.create(:name => menu_name.gsub("_", " ").capitalize, :menu_type => "sub_menu", :is_active => true, :slug => menu_name)
    end
  end
end
puts "Menus Created"

check_role = Role.where(:name => "Administrator")
if check_role.present?
  role = check_role.last
else
  role = Role.create(:is_active => true, :name => "Administrator")
end
puts "Role Created"

Menu.all.each do |menu|
  check_prev_permission = Permission.where(:role_id => role.id, :menu_id => menu.id)
  if check_prev_permission.present?
    if menu.menu_type == "sub_menu"
      check_prev_permission.update(:is_index => true, :is_create => true, :is_view => true, :is_edit => true, :is_delete => true)
    else
      check_prev_permission.update(:is_index => true)
    end
  else
    if menu.menu_type == "sub_menu"
      permission = Permission.new
      permission.role_id = role.id
      permission.menu_id = menu.id.to_i
      permission.is_index = true
      permission.is_create = true
      permission.is_view = true
      permission.is_edit = true
      permission.is_delete = true
      permission.save
    else
      permission = Permission.new
      permission.role_id = role.id
      permission.menu_id = menu.id.to_i
      permission.is_index = true
      permission.save
    end
  end
end
puts "Permissions Created"

check_user = User.where(:email => "admin@support.com")
if check_user.present?
  check_user.update(:role_id => role.id, :is_active => true, :is_logged_in => false)
else
  User.create(:email => "admin@support.com", :password => "Admin@123", :full_name => "Administrator", :is_active => true, :is_logged_in => false, :role_id => role.id, :user_type => "Admin")
end
puts "Admin User Created"
