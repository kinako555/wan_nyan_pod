class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :require_login

    # ログイン済ならユーザーホーム画面に遷移
    # 未ログインならログイン画面に遷移
    def redirect_home_or_login
      if logged_in?
        redirect_to root_path
      else
        render "sessions/new"
      end
    end

    private

      # ログイン済か確認
      # ログイン済みでなければ、ログイン画面へ遷移し、
      # メッセージを表示
      def not_authenticated
        flash[:danger] = "ログインしてください"
        redirect_to login_path
      end
end
