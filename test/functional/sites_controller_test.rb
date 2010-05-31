require 'test_helper'

class SitesControllerTest < ActionController::TestCase
  def setup
    sign_in Factory.create(:user)
  end
  
  test "should show site" do
    get :show
    assert_response :success
  end
end
