class AddPasswordDigestInUsers < ActiveRecord::Migration[7.0]
  def change
    add_column  :users, :password_digest, :string
    add_column  :users, :full_name, :string, default: "System Generated User"
  end
end
