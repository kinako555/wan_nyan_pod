class SessionsController < ApplicationController

  def new
    # ログイン画面に遷移
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        # 正常にログイン
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or root_path # 遷移しようとした画面かログイン画面に遷移
      else
        # ユーザーの有効でない場合
        message  = "有効なアカウントではありません"
        message += "ユーザー確認メールより、ユーザー認証を完了してください"
        flash.now[:warning] = message
        render 'new'
      end
    else
      flash.now[:danger] = 'パスワードまたはEメールアドレスが正しくありません'
      render 'new'
    end
  end

  def destroy
    # 2番目のウィンドウでログアウトするユーザーを想定して
    # ログイン状態の場合のみログアウトする
    log_out if logged_in?
    redirect_to login_path
  end
end
