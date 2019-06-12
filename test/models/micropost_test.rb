require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  # user_idが存在すれば有効である
  test "should be valid" do
    assert @micropost.valid?
  end

  # user_idが存在しなければ無効である
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  # contentが空白スペーズの場合は無効である
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  # contentが141文字以上なら無効である
  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  # Micropostが時刻が新しい順でとれているか
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
