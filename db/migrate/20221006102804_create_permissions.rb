class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions do |t|
      t.boolean :is_index, default: false
      t.boolean :is_create, default: false
      t.boolean :is_view, default: false
      t.boolean :is_edit, default: false
      t.boolean :is_delete, default: false
      t.integer :menu_id
      t.integer :user_id
      t.timestamps
    end
  end
end
