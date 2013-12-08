require 'test_helper'

class SoundcloudUsersControllerTest < ActionController::TestCase
  test "should get stream" do
    get :stream
    assert_response :success
  end

end
