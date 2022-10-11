class AddActionSlugInActivityStream < ActiveRecord::Migration[7.0]
  def change
    add_column  :activity_streams,  :slug,  :string
  end
end
