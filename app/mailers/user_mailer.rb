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
    @url  = login_url
    mail to: user.email, subject: "わんにゃんぽっど【ユーザー認証が完了しました】"
  end
end
