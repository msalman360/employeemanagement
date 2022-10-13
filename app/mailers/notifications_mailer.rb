class NotificationsMailer < ApplicationMailer

  def send_password_recover_email(email, otp, user_id)
    @otp = otp
    @user_id = user_id
    mail to: email, subject: "Account Password Recovery Email (No Reply)"
  end

end
