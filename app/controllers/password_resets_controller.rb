class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  # アドレス入力画面
  def new
  end

  #　メール送信
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
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)
    not_authenticated unless @user
    # パスワード入力画面に遷移
  end

  # パスワード再設定クリック後
  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    if @user.blank?
      not_authenticated
      return
    end

    @user.password_confirmation = params[:user][:password_confirmation]
    # password_digest更新
    # remember_me_tokenをnilに更新
    if @user.change_password!(params[:user][:password])
      flash[:success] = "パスワードを再設定しました。"
      redirect_to root_path
    else
      render :action => "edit"
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

end
