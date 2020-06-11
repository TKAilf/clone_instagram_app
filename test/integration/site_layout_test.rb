require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end  
  
  test "layout links" do
    log_in_as(@user)
    get static_pages_home_path
    assert_template "static_pages/home"
    assert_select "a[href=?]", static_pages_home_path, count: 2
  end
  
end
