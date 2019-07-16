require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:first)
    @other_user = users(:second)
  end

  test "get signup_pathからログイン画面にアクセスできる" do
    get signup_path
    assert_response :success
  end

  test "ユーザー編集ページにアクセス" do
    # 未ログイン => アクセスできない
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url

    # ログイン済 => アクセスできる
    login_user @user
    get edit_user_path(@user)
    assert flash.empty?
    assert_select "h1", "プロフィール設定"
  end

  test "ログインしていない状態でユーザーデータを更新できない" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "ユーザー情報更新の際、パラメーターにadmin(任意以外のパラメータ)が含まれていたら更新を実行しない" do
    login_user @other_user
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              "foobar",
                                            password_confirmation: "foobar",
                                            admin: 1 } }
    assert_not @other_user.reload.admin?
  end

  test "ログインユーザー以外の編集画面に遷移できない" do
    login_user @other_user
    get edit_user_path(@user)
    assert flash.empty?
    # TODO: 遷移先を指定する
    # assert_redirected_to root_url
  end

  test "ログインユーザー以外のユーザーデータを更新できない" do
    login_user @other_user
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    # TODO: 遷移先を指定する
    # assert_redirected_to root_url
  end

  test "ログインしていない状態でユーザー検索ページを指定するとログイン画面に遷移する" do
    get users_path
    assert_redirected_to login_url
  end

  test "ログインしていない場合、ユーザーを削除できない" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "管理者権限を持たないユーザーは他ユーザーを削除できない" do
    login_user @other_user
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    # TODO: about画面に遷移しているので、login_pathにアクセスするようにする
    # assert_redirected_to login_path
  end

  test "ログイン済みでないとフォロー一覧にアクセスできない" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "ログイン済みでないとフォロワーー覧にアクセスできない" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end

end
