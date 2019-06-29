require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:two)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # ユーザー情報更新の際、パラメーターにadminが含まれていたら
  # 更新を実行しない
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              "foobar",
                                            password_confirmation: "foobar",
                                            admin: 1 } }
    assert_not @other_user.reload.admin?
  end

  # ログインユーザーとは別ユーザーを開く際、
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    # TODO: 遷移先を指定する
    # assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    # TODO: 遷移先を指定する
    # assert_redirected_to root_url
  end

  # ログインしていない状態でユーザー検索ページを指定すると、
  # ログイン画面に遷移するか
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  # ログインしていない場合、ユーザーを削除できない
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  # 管理者権限を持たないユーザーはユーザーを削除できない
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_path
  end

  # ログイン済みでないとフォロー一覧にアクセスできない
  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  # ログイン済みでないとフォロワーー覧にアクセスできない
  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end

end
