require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:first)
    @other_user = users(:second)
    @pending_user = users(:pending_user)
    @icon = get_icon
  end

  # 1 GET root_path: ホーム画面------

  test "1 ログイン済ならホーム画面に遷移する" do
    login_user @user
    get root_path
    assert_response :success
  end

  test "1 未ログインならログイン画面に遷移する" do
    get root_path
    assert_redirected_to login_path
  end

  # 2 GET users_path: ユーザー検索画面------

  test "2 ログイン済ならユーザー検索ページに遷移できる" do
    login_user @user
    get users_path
    # 成功時の処理を書く
    # assert_redirected_to users_path
  end

  test "2 未ログインならユーザー検索ページを指定するとログイン画面に遷移する" do
    get users_path
    assert_redirected_to login_path
  end

  # 3 GET users_path(User): microposts-----
  # ログインユーザーならタイムライン、その他ユーザーならユーザーのmicropostsのみ

  test "3 ログイン済ならタイムライン画面に遷移する" do
    login_user @user
    get users_path(@user)
    assert_response :success
    # TODO: タイムラインかどうかの確認
  end

  test "3 ログイン済ならmicroposts画面に遷移する" do
    login_user @user
    get users_path @other_user
    assert_response :success
    # TODO: micropostsかどうかの確認
  end
    
  test "3 未ログインならログイン画面に遷移する" do
    get users_path(@user)
    assert_redirected_to login_path
  end

  # 4 GET signup_path: ユーザー登録画面-----
  
  test "4 未ログインならユーザー登録画面に遷移する" do
    get signup_path
    assert_response :success
  end

  test "4 ログイン済ならユーザーホーム画面に遷移する" do
    login_user @user
    get signup_path
    assert_redirected_to root_path
  end

  # 5 POST users_path: ユーザー登録処理-----

  test "5 値が適切なら登録できる" do
    
  end

  test "5 値が適切でないなら登録できない" do
    
  end

  # 6 GET activate_user_url(User): ユーザー有効化-----
  # 手動で実行

  # 7 GET edit_user_path(User): プロフィール設定画面-----
  
  test "7 ログイン済ならプロフィール設定画面に遷移する" do
    login_user @user
    get edit_user_path @user
    assert flash.empty?
    assert_select "h1", "プロフィール設定"
  end

  test "7 未ログインならプロフィール設定画面に遷移する" do
    get edit_user_path @user
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "7 ログインユーザー以外ならユーザーホーム画面に遷移" do
    login_user @other_user
    get edit_user_path @user
    assert_redirected_to root_path
  end

  # 8 PATCH user_path: データ更新-----

  test "8 ログイン済ならユーザーデータを更新できる" do
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

  test "8 未ログインならユーザーデータを更新できない" do
    befor_name = @user.name
    befor_email = @user.email
    patch user_path(@user), params: { icon:                  @icon,
                                      name:                  "nyanko",
                                      email:                 "bbb@d.jp", 
                                      password:              "abcdef",
                                      password_confirmation: "abcdef"   }
    assert_redirected_to login_url
    @user.reload
    assert_equal @user.name, befor_name
    assert_equal @user.email, befor_email 
  end

  test "8 ログインユーザー以外のユーザーデータを更新できない" do
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
    assert_redirected_to root_path
    @other_user.reload
    assert_equal @other_user.name, befor_name
    assert_equal @other_user.email, befor_email
  end

  test "8 ユーザー情報更新の際、パラメーターにadmin(任意以外のパラメータ)が含まれていたら更新を実行しない" do
    login_user @other_user
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { icon:                  @icon,
                                            name:                  "nyanko",
                                            email:                 "bbb@d.jp", 
                                            password:              "abcdef",
                                            password_confirmation: "abcdef",
                                            admin: 1                        }
    assert_not @other_user.reload.admin?
  end

  # 9 DELETE users_path(User): ユーザー削除---------------------------------------------------------------

  test "9 ログイン済で管理権限持ちならユーザーを削除できる" do
    login_user @user
    assert_difference 'User.count', -1 do
      delete user_path @other_user 
    end
    assert_redirected_to users_url
  end

  test "9 未ログインならユーザーを削除できない" do
    assert_no_difference 'User.count' do
      delete user_path @other_user 
    end
    assert_redirected_to login_url
  end

  test "9 管理者権限を持たないユーザーは他ユーザーを削除できない" do
    login_user @other_user
    assert_no_difference 'User.count' do
      delete user_path @user
    end
    # TODO: about画面に遷移しているので、login_pathにアクセスするようにする
    # assert_redirected_to login_path
  end

  # フォロワー一覧ページにアクセス-------------------------------------------

  test "ログイン済ならフォロワー一覧にアクセスできる" do
    login_user @user
    get following_user_path @user
    assert_response :success
  end

  test "未ログインならフォロワーー覧にアクセスできない" do
    get followers_user_path @user
    assert_redirected_to login_url
  end

end
