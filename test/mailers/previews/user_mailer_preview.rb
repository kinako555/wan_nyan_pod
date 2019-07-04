# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/activation_needed_email
  def activation_needed_email
    user = User.first
    user.activation_token = new_token
    UserMailer.activation_needed_email(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/activation_success_email
  def activation_success_email
    user = User.first
    UserMailer.activation_success_email(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/reset_password_email
  def reset_password_email
    user = User.first
    user.reset_password_token = new_token
    UserMailer.reset_password_email(user)
  end

  private

    # ランダムなトークンを返す
    def new_token
      SecureRandom.urlsafe_base64
    end

end
