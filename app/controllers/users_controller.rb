class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.where(activated: true)
    # ユーザー検索画面に遷移
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts
    # 検索したユーザーが有効であればユーザーホーム画面に遷移
    # 無効な場合はabout画面
    redirect_to about_path and return unless @user.activated?
  end

  def new
    @user = User.new
    # ログイン画面に遷移
  end

  # ユーザー登録処理
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "ユーザー登録はまだ終了していません。ユーザー確認メールを送信したので、メールよりユーザー認証を完了してください。"
      redirect_to login_path # ログイン画面に遷移
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    # プロフィール設定画面に遷移
  end

  # # プロフィール設定画面登録処理
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを更新しました"
      redirect_to @user # ユーザーホーム画面に遷移
    else
      render 'edit'
    end
  end

  # ユーザー削除実行
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_url # 検索画面に遷移
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # beforeアクション

    # ログイン済か確認
    # ログイン済みでなければ、ログイン画面へ遷移し、
    # メッセージを表示
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # 正しいユーザーか確認
    # 正しいユーザーでなければログイン画面に繊維
    def correct_user
      @user = User.find(params[:id])
      # TODO: 遷移先を変える (current_userからユーザーを参照する？)
      redirect_to(about_path) unless current_user?(@user)
    end

    # 管理者か確認
    # 管理者でなければabout画面に遷移する
    def admin_user
      redirect_to(about_path) unless current_user.admin?
    end
end
