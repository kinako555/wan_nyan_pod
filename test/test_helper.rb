ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
 
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def is_logged_in?
    !session[:user_id].nil?
  end

  # Sorcery::TestHelperが使用できないので自装
  def login_user(user, password="password", remember_me=false)
    user ||= users(:first)
    post login_path, params: { session: { email:       user.email,
                                           password:    password,
                                           remember_me: remember_me }}
    follow_redirect! # 画面遷移
  end

  # アイコン画像をオブジェクトとして返す
  def get_icon
    image_path = File.join(Rails.root, "test/images/icon_test.png")
    File.new(image_path)
  end
end

class ActionDispatch::IntegrationTest

  # テストユーザーとしてログインする
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
  
end