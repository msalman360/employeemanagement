class CreateAttendances < ActiveRecord::Migration[7.0]
  def change
    create_table :attendances do |t|
      t.string "attendance_type"
      t.string "slug"
      t.integer "employee_id"
      t.datetime "start_time"
      t.datetime "end_time"
      t.date "date"

      t.timestamps
    end
  end
end
