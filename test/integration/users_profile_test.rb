require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  # ユーザーページデザイン
  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'h1', text: @user.name
    assert_match @user.microposts.count.to_s, response.body
    @user.microposts.each do |micropost|
      assert_match micropost.content, response.body
    end
  end

end
