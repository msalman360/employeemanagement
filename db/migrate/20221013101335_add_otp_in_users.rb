class AddOtpInUsers < ActiveRecord::Migration[7.0]
  def change
    add_column  :users, :otp, :string, default: nil
  end
end
