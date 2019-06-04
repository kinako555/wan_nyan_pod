require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  # フラッシュメッセージが画面遷移後に消えているか
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get login_path
    assert flash.empty?
  end

  # ログイン後、ログアウト後の画面リンク先確認
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path,       count: 0
    assert_select "a[href=?]", logout_path,      count: 1
    assert_select "a[href=?]", about_path,       count: 1
    assert_select "a[href=?]", user_path(@user), count: 1
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to login_path
    follow_redirect!
    # ログインボタンと合わせて2つ
    assert_select "a[href=?]", login_path,       count: 2
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", about_path,       count: 1
    assert_select "a[href=?]", user_path(@user), count: 0

  end
end
