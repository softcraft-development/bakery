require 'test_helper'

class Site::MailsControllerTest < ActionController::TestCase
  def test_show_should_redirect_to_new
    sign_in Factory.create(:admin)
    get :show
    assert_response :redirect
  end
  
  # TODO: Macro this test with shoulda
  def test_should_show_site_to_admin
    sign_in Factory.create(:admin)
    get :new
    assert_response :success
  end

  # TODO: Macro this test with shoulda
  def test_shold_not_show_to_non_admin
    sign_in Factory.create(:user)
    get :new
    assert_response :redirect
  end
  
  # TODO: Macro this test with shoulda
  def test_shold_not_show_to_guest
    sign_out :user
    get :new
    assert_response :redirect
  end
end
