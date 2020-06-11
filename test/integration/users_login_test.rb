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
    delete logout_path
    follow_redirect!
  end
  
  test "login with remember_check" do
    log_in_as(@user)
    assert_equal cookies[:remember_token], assigns(:user).remember_token
  end
  
  test "login without remember_check after login with remember_check" do
    log_in_as(@user)
    delete logout_path
    log_in_as(@user, remember_me: "0")
    assert_empty cookies["remember_token"]
  end
  
end
