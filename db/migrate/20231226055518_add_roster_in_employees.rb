class AddRosterInEmployees < ActiveRecord::Migration[7.0]
  def change
    add_column :employees,:roster_id, :integer
    add_column :employees,:salary, :float, :default => 0.0
  end
end
