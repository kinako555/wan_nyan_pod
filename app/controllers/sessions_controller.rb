class SessionsController < ApplicationController

  skip_before_action :require_login,     only: [:new, :create]
  before_action      :check_logged_out,  only: [:new, :create]

  def new
    # ログイン画面に遷移
  end

  def create
    # ログイン済ならユーザーホーム画面に遷移
    redirect_to root_path if logged_in?
    @user = login(params[:session][:email].downcase, 
                  params[:session][:password], 
                  params[:session][:remember_me])
    if @user
        # 正常にログイン
        redirect_back_or_to root_path # 遷移しようとした画面かログイン画面に遷移
    else
      # 入力が間違っている
      # ユーザーがactiveでない
      flash.now[:danger] = 'ログインに失敗しました。'
      render 'new'
    end
  end

  def destroy
    # ログイン状態の場合のみログアウトする
    logout
    redirect_to login_path
  end
end
