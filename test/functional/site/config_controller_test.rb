require 'test_helper'

class Site::ConfigControllerTest < ActionController::TestCase
  def test_show_success
    get :show
    assert_response :success
  end
end
