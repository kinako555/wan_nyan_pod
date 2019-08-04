require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:first)
    @other_user = users(:second)
  end
  
  test "未ログインならログイン画面に遷移する" do
    get login_path
    assert_response :success
  end

  test "" do
    
  end

end
