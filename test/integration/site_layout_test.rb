require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  test "layout links" do
    get static_pages_home_path
    assert_template "static_pages/home"
    assert_select "a[href=?]", static_pages_home_path, count: 2
  end
  
end
