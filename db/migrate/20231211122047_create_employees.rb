class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
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
      t.timestamps
    end
  end
end
