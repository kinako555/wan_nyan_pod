require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  #test "should get help" do
  #  get static_pages_help_url
  #  assert_response :success
  #end

  test "should get about" do
    get about_path
    assert_response :success
  end

end
