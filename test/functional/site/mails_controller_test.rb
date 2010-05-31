require 'test_helper'

class Site::MailsControllerTest < ActionController::TestCase
  def setup
    sign_in Factory.create(:user)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end
end
