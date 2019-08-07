class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :require_login

    # 未ログアウトなら従来の処理
    # ログイン済ならユーザーホーム画面に遷移
    def check_logged_out
      redirect_to root_path if logged_in?
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
