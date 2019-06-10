class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  # アドレス入力画面
  def new
  end

  #　メール送信
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user # 存在するメールアドレスだった場合 
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "入力されたアドレスにメールを送信しました。"
      redirect_to login_path
    else # 存在しないメールアドレスだった場合 
      flash.now[:danger] = "Eメールアドレスが間違っています。"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      # パスワードが空の場合
      # TODO: ユーザー設定が完了次第、この分岐を消す
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      # パスワード再設定後にパスワードを再設定されないように
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する
    def valid_user
      unless (@user && 
              @user.activated? &&
              @user.authenticated?(:reset, params[:id])) # params[:id]でreset_tokenを参照できる

        redirect_to login_path
      end
    end

    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "リンクの有効期限が切れています。"
        redirect_to new_password_reset_url
      end
    end
end
