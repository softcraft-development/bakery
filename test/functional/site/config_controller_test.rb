require 'test_helper'

class Site::ConfigControllerTest < ActionController::TestCase
  def setup
    sign_in Factory.create(:user)
  end
  
  def test_show_success
    get :show
    assert_response :success
  end
end
