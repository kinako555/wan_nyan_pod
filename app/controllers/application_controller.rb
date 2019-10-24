class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :require_login
    rescue_from Exception,                    with: :error_500
    rescue_from ActiveRecord::RecordNotFound, with: :error_404

    # ActiveRecord::RecordNotFound発生時のレンダリング先
    ERROR_404_RENDER_JS = 'shared/error_404'.freeze
    # Exception発生時のレンダリング先
    ERROR_500_RENDER_JS = 'shared/error_500'.freeze
    ERROR_404_MESSAGE = '処理に失敗しました。'.freeze
    

    # 未ログアウトなら従来の処理
    # ログイン済ならユーザーホーム画面に遷移
    def check_logged_out
      redirect_to root_path if logged_in?
    end

    def error_500(e)
      p e
      logger.error e
      flash[:danger] = "処理に失敗しました。"
      redirect_to root_path
    end

    def error_404(e)
      p "エラー内容：#{e}"
      respond_to do |format|
        format.js { render ERROR_404_RENDER_JS }
      end
    end

    # redirect先を指定する場合の404エラー
    def error_404_redirect
      redirect_to root_path
      flash[:danger] = ERROR_404_MESSAGE
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
