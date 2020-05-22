require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "redirect_to login_path without log in when access index" do
    get users_path
    assert_redirected_to login_path
  end
  
  test "should get new" do
    get new_user_url
    assert_template "users/new"
  end
  
  test "redirect_to root with different user when access edit form" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "redirect_to root with different user when access update form" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "admin can't change to be edit with not allow admin" do
    log_in_as @other_user
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { user: { password: @other_user.password,
                                                    password_confirmation: @other_user.password,
                                                    admin: true } }
    assert_not @other_user.reload.admin?
  end
  
  test "redirect_to login form when not login" do
    assert_no_difference "User.count" do
      delete user_path @user
    end
    assert_redirected_to login_path
  end
  
  test "redirect_to static_pages_home_path when logged in not admin user" do
    log_in_as @other_user
    assert_no_difference "User.count" do
      delete user_path @user
    end
    assert_redirected_to static_pages_home_path
  end

end
