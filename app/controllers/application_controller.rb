class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :require_login

    private

    # ログイン済か確認
    # ログイン済みでなければ、ログイン画面へ遷移し、
    # メッセージを表示
    def logged_in_user
        unless logged_in?
          store_location
          flash[:danger] = "ログインしてください"
          redirect_to login_url
        end
    end

    # ログイン済か確認
    # ログイン済みでなければ、ログイン画面へ遷移し、
    # メッセージを表示
    def not_authenticated
      redirect_to login_path, alert: "please login first"
    end
end
