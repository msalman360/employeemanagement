class CreatePayItems < ActiveRecord::Migration[7.0]
  def change
    create_table :pay_items do |t|
      t.integer  "company_id"
      t.integer  "employee_id"
      t.float    "item_amount",        default: 0.0
      t.boolean  "is_active",          default: false
      t.string   "item_name",          default: ""
      t.string   "payment_type",       default: "Earning"
      t.string   "item_type",          default: "Recurring"
      t.datetime "pay_month"
      t.date "start_date"
      t.date "end_date"
      t.string   "formatted_pay_month"
      t.string   "slug"              ,default: ""
      t.text     "description"
      t.timestamps
    end
  end
end
