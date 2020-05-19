require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "not login with invalid information" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: "", password: "" } }
    assert_template "sessions/new"
    assert_not flash.empty?
    get signup_path
    assert flash.empty?
  end
  
  test "logout after login with valid information" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: @user.email, password: "password" } }
    assert_redirected_to static_pages_home_path
    follow_redirect!
    assert_template "static_pages/home"
    assert is_logged_in?
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    follow_redirect!
  end
  
end
