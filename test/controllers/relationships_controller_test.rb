require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:first)
    @unFollowed_user = users(:second) # @userがフォローしていないユーザー
  end

  # 1 POST relationships_path
  # フォロー--

  test "1 ログイン済ならフォローを実行できる" do
    login_user @user
    assert_difference 'Relationship.count', 1 do
      post relationships_path, params: {followed_id: @unFollowed_user.id}
    end
  end

  test "1 ログイン済でないとフォローを実行できない" do
    assert_no_difference 'Relationship.count' do
      post relationships_path, params: {followed_id: @unFollowed_user.id}
    end
    assert_redirected_to login_url
  end

  # 2 DELETE relationships_path(Relationship)
  # フォロー解除--
  
  test "2 ログイン済ならフォロー解除を実行できる" do
    login_user @user
    assert_difference 'Relationship.count', -1 do
      delete relationship_path(relationships(:one))
    end
  end
  
  test "2 未ログインならフォロー解除を実行できない" do
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationships(:one))
    end
    assert_redirected_to login_url
  end

end
