class SessionsController < ApplicationController

  skip_before_action :require_login,     only: [:new, :create]
  before_action      :check_logged_out,  only: [:new, :create]

  # GET login_path
  # login_path
  def new
    # ログイン画面に遷移
  end

  # POST sessions_path
  # ログイン
  def create
    # ログイン済ならユーザーホーム画面に遷移
    redirect_to root_path if logged_in?
    @user = login(params[:session][:email].downcase, 
                  params[:session][:password], 
                  params[:session][:remember_me])
    if @user # 正常にログイン
        # 遷移しようとした画面かユーザーホーム画面に遷移
        redirect_back_or_to root_path 
    else # 入力が間違っているかユーザーがactiveでない
      flash.now[:danger] = 'ログインに失敗しました。'
      render 'new'
    end
  end

  # DELETE sessions_path
  # ログアウト
  def destroy
    # ログイン状態の場合のみログアウトする
    logout
    redirect_to login_path
  end
end
