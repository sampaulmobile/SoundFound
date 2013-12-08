require 'test_helper'

class SoundcloudControllerTest < ActionController::TestCase
  test "should get connected" do
    get :connected
    assert_response :success
  end

end
