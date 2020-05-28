require 'test_helper'

class FacebooksControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get facebooks_new_url
    assert_response :success
  end

end
