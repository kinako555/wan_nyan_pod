class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  # アドレス入力画面
  def new
  end

  # メール送信
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)

    if @user # 存在するメールアドレスだった場合 
      # パスワードリセット実行メール送信
      # remember_me_token, remember_me_token_expires_at 作成
      @user.deliver_reset_password_instructions!
      flash[:info] = "入力されたアドレスにメールを送信しました。"
      redirect_to root_path
    else
      # 存在しないメールアドレスだった場合 
      flash.now[:danger] = "Eメールアドレスが間違っています。"
      render 'new'
    end
  end

  def edit
    load_user_from_reset_password_token? params[:id]
    # パスワード入力画面に遷移
  end

  # パスワード再設定クリック後
  def update
    return unless load_user_from_reset_password_token? params[:id]

    # パスワード入力チェックをするためsorceryを使わずに自装
    if @user.update_attributes(user_params)
      @user.update_attribute(:reset_password_token, nil)
      flash[:success] = "パスワードを再設定しました。"
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # パラメーターで受けとたトークンが存在しない、
    # または期限切れの場合はログイン画面に戻る
    def load_user_from_reset_password_token?(token)
      @token = token # viewに持たせるため変数に代入しておく
      @user = User.load_from_reset_password_token(@token)
 
      if @user.blank?
        not_authenticated
        return false
      else
        return true
      end
    end
end
