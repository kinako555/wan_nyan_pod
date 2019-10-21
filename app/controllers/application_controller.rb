class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :require_login
    rescue_from ActiveRecord::RecordNotFound, with: :error_404
    rescue_from Exception,                    with: :error_500

    # 未ログアウトなら従来の処理
    # ログイン済ならユーザーホーム画面に遷移
    def check_logged_out
      redirect_to root_path if logged_in?
    end

    def error_500(e)
      #TODO: 処理を書く
    end

    def error_500(e)
      logger.error e
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
