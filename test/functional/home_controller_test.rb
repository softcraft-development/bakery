require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  # TODO: Reenable for Shoulda on Rails 3
  # context "The Home" do
  #   context "show page" do
  #     setup do
  #       get :show
  #     end
  #     
  #     should_respond_with :success
  #     should_render_template :show
  #     should_not_set_the_flash      
  #   end    
  # end
  
  def test_The_Home_page_should_respond_with_success
    get(:show)
    assert_response :success
  end
end
