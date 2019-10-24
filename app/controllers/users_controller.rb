class UsersController < ApplicationController
  include UsersHelper

  skip_before_action :require_login, only: [:home, :show, :new, :create, :activate]
  before_action      :correct_user,  only: [:edit, :update]
  before_action      :admin_user,    only: :destroy

  # GET root_path
  def home
    if logged_in? 
      @user = current_user
      # buildでnilデータが作成されているので
      # nilをはじく必要がある
      @microposts = @user.home_microposts
      @micropost =  current_user.microposts.build
      @sharering_or_favoriting_users = []
      # ホーム画面に遷移
    else
      redirect_to login_path
    end
  end

  # GET users_path
  def index
    @users = []
    @microposts = []
    @sharering_or_favoriting_users = []
    # ユーザー検索画面に遷移
  end

  # GET users_path(User)
  # @userでもいける
  # タイムライン
  def show
    # 該当なしの場合nilを返したいのでfind_byを使用(例外処理をしない)
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
    @sharering_or_favoriting_users = []
  end

  # GET signup_path
  def new
    unless logged_in? # 未ログイン時のみ
      @user = User.new
      # ユーザー登録画面に遷移
    else
      redirect_to root_path
      # ユーザーホーム画面に遷移
    end
  end

  # POST users_path
  # ユーザー登録処理
  def create
    if logged_in?
      edirect_to root_path
      # ユーザーホーム画面に遷移
    end
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

  # GET activate_user_url(User.activation_token)
  # ↑ users/activation_token/activate
  # ユーザー認証メールのリンクをクリック後
  def activate
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

  # GET edit_user_path(User)
  # ↑ users/User.id/edit
  def edit
    @user = current_user
    @default_edit_type = EditType::PROFILE
    # プロフィール設定画面に遷移
  end

  # PATCH user_path
  # プロフィール設定画面登録処理
  # ajax通信処理
  def update
    @user = current_user
    case params[:user][:edit_type]
    when EditType::PROFILE then
      name = params[:user][:name]
      email = params[:user][:email]
      values = { name: name, email: email }
      values["icon"] = params[:user][:icon] if params[:user][:icon]

      if  @user.update_attributes(values)
        flash[:success] = "更新しました。"
        redirect_to root_path
      else
        @default_edit_type = EditType::PROFILE
        flash[:danger] = "入力が正しくありません。"
        render 'edit'
      end
    when EditType::PASSWORD then
      password = params[:user][:password]
      password_confirmation = params[:user][:password_confirmation]
      values = { password: password, password_confirmation: password_confirmation }

      if @user.update_attributes(values)
          flash[:success] = "更新しました。"
          redirect_to root_path
      else
        @default_edit_type = EditType::PASSWORD
        render 'edit'
      end                         
    end
  end

  # POST search_path
  def search
    case params[:search_type]
    when "users" then
      @users = User.where("activation_state = ? AND name LIKE ?", 
                          User::ActivationState::ACTIVE, 
                          "%#{params[:search_txt]}%")
      @microposts = []
      @searchType = 0 # js.erbが「'」を処理できないので数字にする ← 対応可能なので後に対応
      @sharering_or_favoriting_users = []
      respond_to do |format|
        # どちらかを実行
        format.html { redirect_to users_path }
        format.js
      end
    when "microposts" then
      @users = []
      @microposts = Micropost.where("content LIKE ?", "%#{params[:search_txt]}%")
                             .order(:updated_at)
      @searchType = 1
      @sharering_or_favoriting_users = []
      respond_to do |format|
        # どちらかを実行
        format.html { redirect_to users_path }
        format.js
      end
    end
  end

  # DELETE users_path(User)
  # ユーザー削除実行
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_url # 検索画面に遷移

  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
    flash[:danger] = ERROR_404_MESSAGE
  end

  # GET following_user_path(User)
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following
    render 'show_follow'

  rescue ActiveRecord::RecordNotFound
    error_404_redirect
  end

  # GET followers_user_path(User)
  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers
    render 'show_follow'

  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
    flash[:danger] = ERROR_404_MESSAGE
  end

  # GET favoriting_microposts_user_path(User)
  def favoriting_microposts
    @title = "お気に入りリスト"
    @user = current_user
    @microposts = @user.sorted_favoriting_microposts
    @sharering_or_favoriting_users = []
    render 'show_favorite_micropost'
  end

  private

    def user_create_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    def a(v_params)
      name = v_params[:user][:name]
      email = v_params[:user][:email]
      password = v_params[:user][:password]
      password_confirmation = v_params[:user][:password_confirmation]
      icon = ""
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
      redirect_to(root_path) unless current_user?(@user)

    rescue ActiveRecord::RecordNotFound
      error_404_redirect
    end

    # 管理者か確認
    # 管理者でなければabout画面に遷移する
    def admin_user
      redirect_to(about_path) unless current_user.admin?
    end

end
