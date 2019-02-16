require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get indez" do
    get home_indez_url
    assert_response :success
  end

end
