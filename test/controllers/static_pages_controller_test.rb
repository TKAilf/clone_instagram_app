require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "should get home" do
    log_in_as(@user)
    get static_pages_home_url
    assert_response :success
  end

end
