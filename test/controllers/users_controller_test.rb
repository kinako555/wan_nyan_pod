require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:first)
    @other_user = users(:second)
    @icon = get_icon
  end

  # ログイン画面にアクセス--------------------------------------------------------

  test "get signup_pathからログイン画面にアクセスできる" do
    get signup_path
    assert_response :success
  end

  # ユーザー編集ページへのアクセス-----------------------------------------------

  test "ログイン済ならユーザー編集ページにアクセスできる" do
    login_user @user
    get edit_user_path(@user)
    assert flash.empty?
    assert_select "h1", "プロフィール設定"
  end

  test "未ログインならユーザー編集ページにアクセスできない" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "ログインユーザー以外のユーザー編集ページにアクセスできない" do
    login_user @other_user
    get edit_user_path(@user)
    assert flash.empty?
    # TODO: 遷移先を指定する
    # assert_redirected_to root_url
  end

  # データ更新-----------------------------------------------------------

  test "ログイン済ならユーザーデータを更新できる" do
    login_user @user

    name = "wanko"
    email = "aasssa@dsss.jp"
    patch user_path(@user), params: { icon:                  @icon,
                                      name:                  name,
                                      email:                 email, 
                                      password:              "aaaaaa",
                                      password_confirmation: "aaaaaa" }
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end

  test "未ログインならユーザーデータを更新できない" do
    patch user_path(@user), params: { icon:                  @icon,
                                      name:                  "nyanko",
                                      email:                 "bbb@d.jp", 
                                      password:              "abcdef",
                                      password_confirmation: "abcdef"   }
    assert_redirected_to login_url
  end

  test "ログインユーザー以外のユーザーデータを更新できない" do
    login_user @user

    befor_name = @other_user.name
    befor_email = @other_user.email

    name = "wanko"
    email = "aasssa@dsss.jp"
    patch user_path(@other_user), params: { icon:                  @icon,
                                            name:                  name,
                                            email:                 email, 
                                            password:              "aaaaaa",
                                            password_confirmation: "aaaaaa" }
    assert_redirected_to login_path
    @other_user.reload
    assert_equal @other_user.name, befor_name
    assert_equal @other_user.email, befor_email
  end

  test "ユーザー情報更新の際、パラメーターにadmin(任意以外のパラメータ)が含まれていたら更新を実行しない" do
    login_user @other_user
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { icon:                  @icon,
                                            name:                  "nyanko",
                                            email:                 "bbb@d.jp", 
                                            password:              "abcdef",
                                            password_confirmation: "abcdef",
                                            admin: 1                        }
    # TODO: リダイレクト先を確認する
    #assert_redirected_to login_url
    assert_not @other_user.reload.admin?
  end

  # ユーザー検索ページに遷移----------------------------------------------------

  test "ログイン済ならユーザー検索ページに遷移できる" do
    login_user @user
    get users_path
    # 成功時の処理を書く
    # assert_redirected_to users_path
  end

  test "未ログインならユーザー検索ページを指定するとログイン画面に遷移する" do
    get users_path
    assert_redirected_to login_url
  end

  # ユーザー削除---------------------------------------------------------------

  test "ログイン済で管理権限持ちならユーザーを削除できる" do
    login_user @user
    assert_difference 'User.count' do
      delete user_path @other_user 
    end
    assert_redirected_to login_url
  end

  test "未ログインならユーザーを削除できない" do
    assert_no_difference 'User.count' do
      delete user_path @other_user 
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

  # フォロワー一覧ページにアクセス-------------------------------------------

  test "ログイン済みでないとフォロー一覧にアクセスできない" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "ログイン済みでないとフォロワーー覧にアクセスできない" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end

end
