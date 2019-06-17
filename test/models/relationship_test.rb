require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @relationship = Relationship.new(follower_id: users(:michael).id,
                                     followed_id: users(:archer).id)
  end

  # follower_idとfollowed_idが存在すれば有効である
  test "should be valid" do
    assert @relationship.valid?
  end

  # follower_idが存在しなければ無効である
  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  # followed_idが存在しなければ無効である
  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end

end
