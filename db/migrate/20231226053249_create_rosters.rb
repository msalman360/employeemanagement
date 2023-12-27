class CreateRosters < ActiveRecord::Migration[7.0]
  def change
    create_table :rosters do |t|
      t.string :name
      t.string :client
      t.string :shift_type
      t.string :employee_id
      t.boolean :is_active
      t.string :slug
      t.timestamps
    end
  end
end
