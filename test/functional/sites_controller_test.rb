require 'test_helper'

class SitesControllerTest < ActionController::TestCase
  test "should show site" do
    get :show
    assert_response :success
  end
end
