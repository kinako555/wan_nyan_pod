require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest

  # ログイン済でないとフォローを実行できない
  test "create should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      post relationships_path
    end
    assert_redirected_to login_url
  end

  # ログイン済でないとフォロー解除を実行できない
  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationships(:one))
    end
    assert_redirected_to login_url
  end

end
