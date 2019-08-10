require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:first)
    @other_user = users(:second)
  end
  
  test "未ログインならログイン画面に遷移する" do
    #get login_path
    #assert_select "h1", "ログイン"
  end

  test "ログイン済ならユーザーホーム画面に遷移する" do
    #login_user @user
    #get login_path
    #assert_select "h1", "ユーザーホーム"
  end

end
