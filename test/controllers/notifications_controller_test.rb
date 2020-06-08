require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    log_in_as(users(:michael))
    get notifications_url
    assert_response :success
  end

end
