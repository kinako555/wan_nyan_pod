class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_needed_email.subject
  #
  def activation_needed_email(user)
    @user = user
    mail to: user.email, subject: "わんにゃんぽっど【ユーザー確認メール】"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_success_email.subject
  #
  def activation_success_email(user)
    @user = user
    mail to: user.email, subject: "わんにゃんぽっど【ユーザー認証が完了しました】"
  end

  def reset_password_email(user)
    @user = user
    @url = edit_password_reset_url(@user.reset_password_token)
    mail to: user.email, subject: "わんにゃんぽっど【パスワード再設定】"
  end
end
