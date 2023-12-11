# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_12_11_124311) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_streams", force: :cascade do |t|
    t.integer "table_id"
    t.integer "user_id"
    t.string "table_name"
    t.string "ip_address"
    t.string "browser_name"
    t.string "action_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "action_date"
    t.datetime "action_datetime"
    t.string "slug"
  end

  create_table "attendances", force: :cascade do |t|
    t.string "attendance_type"
    t.string "slug"
    t.integer "employee_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dashboards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string "employee_name"
    t.string "department"
    t.string "ip_address"
    t.string "password"
    t.boolean "is_active", default: false
    t.string "slug"
    t.string "employee_code"
    t.string "department_id"
    t.string "designation_id"
    t.string "location_id"
    t.string "company_id"
    t.string "email"
    t.string "hiring_shift"
    t.string "phone_number"
    t.string "working_shift"
    t.string "timing"
    t.string "gender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "login_histories", force: :cascade do |t|
    t.integer "user_id"
    t.string "ip_address"
    t.string "browser_name"
    t.boolean "is_active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menus", force: :cascade do |t|
    t.string "name"
    t.boolean "is_active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", default: ""
    t.string "menu_type", default: ""
    t.integer "main_menu_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.boolean "is_index", default: false
    t.boolean "is_create", default: false
    t.boolean "is_view", default: false
    t.boolean "is_edit", default: false
    t.boolean "is_delete", default: false
    t.integer "menu_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.boolean "is_active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "statuses", force: :cascade do |t|
    t.boolean "is_active", default: false
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name", default: "System User"
    t.string "user_type", default: "user"
    t.boolean "is_active", default: false
    t.boolean "is_logged_in", default: false
    t.integer "role_id"
    t.string "otp"
  end

end
