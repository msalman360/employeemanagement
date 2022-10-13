class CreateStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :statuses do |t|
      t.boolean :is_active, default: false
      t.string  :name
      t.string  :slug
      t.timestamps
    end
  end
end
