class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :require_login

    private

      # ログイン済か確認
      # ログイン済みでなければ、ログイン画面へ遷移し、
      # メッセージを表示
      def not_authenticated
        flash[:danger] = "ログインしてください"
        redirect_to login_path
      end
end
