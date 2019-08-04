class UsersController < ApplicationController
  skip_before_action :require_login, only: [:home, :show, :new, :create, :activate]
  before_action      :correct_user,  only: [:edit, :update]
  before_action      :admin_user,    only: :destroy

  def home
    # rootパスとして使用しているため、メッセージは表示しない
    if logged_in? 
      @user = current_user
      # buildでnilデータが作成されているので
      # nilをはじく必要がある
      @microposts = @user.microposts
      @micropost =  current_user.microposts.build
      # ホーム画面に遷移
    else
      redirect_to login_path
    end
  end

  def index
    @users = User.where(activation_state: "active")
    # ユーザー検索画面に遷移
  end

  def show
    # 該当なしの場合nilを返したいのでfind_byを使用
    @user = User.find_by(id: params[:id])
    # 検索したユーザーが無効であればユーザーホーム画面に遷移
    redirect_to login_path and return if @user.nil? || !@user.activated?
    # ユーザー本人ならtimelineを表示
    if @user == current_user
      @micropost = current_user.microposts.build
      @microposts = @user.timeline
    else
      @microposts = @user.microposts
    end
  end

  def new
    @user = User.new
    # ユーザー登録画面に遷移
  end

  # ユーザー登録処理
  def create
    @user = User.new(user_create_params)
    # save時に
    # メール送信
    # active_token, activation_token_expires_atを作成 
    if @user.save
      flash[:info] = "ユーザー登録はまだ終了していません。ユーザー確認メールを送信したので、メールよりユーザー認証を完了してください。"
      redirect_to login_path # ログイン画面に遷移
    else
      flash[:danger] = "ユーザー登録に失敗しました。"
      render 'new'
    end
  end

  # ユーザー認証メールのリンクをクリック後
  def activate
    p params[:id]
    if (@user = User.load_from_activation_token(params[:id]))
      # 認証完了メール送信
      # activation_tokenをnilに更新
      # activation_stateを'active'に更新
      @user.activate!
      flash[:success] = "「わんにゃんぽっど」へようこそ"
      redirect_to login_path
    else
      flash[:danger] = "ユーザー認証に失敗しました。"
      redirect_to login_path
    end
  end

  def edit
    @user = User.find(params[:id])
    # プロフィール設定画面に遷移
  end

  # # プロフィール設定画面登録処理
  def update
    if current_user.update_attributes(user_update_params)
      flash[:success] = "プロフィールを更新しました"
      redirect_to current_user
    else
      #TODO: 遷移先画面でメッセージを表示させる
      render 'edit'
    end
  end

  # ユーザー削除実行
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_url # 検索画面に遷移
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers
    render 'show_follow'
  end

  private

    def user_create_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    def user_update_params
      params.permit(:icon, :name, :email, :password,
                    :password_confirmation)
    end

    # beforeアクション

    # 正しいユーザーか確認
    # 正しいユーザーでなければログイン画面に繊維
    def correct_user
      @user = User.find(params[:id])
      # TODO: 遷移先を変える (current_userからユーザーを参照する？)
      redirect_to(login_path) unless current_user?(@user)
    end

    # 管理者か確認
    # 管理者でなければabout画面に遷移する
    def admin_user
      redirect_to(about_path) unless current_user.admin?
    end

end
