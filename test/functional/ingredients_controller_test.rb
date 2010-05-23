require 'test_helper'

class IngredientsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    ingredient = Factory.create(:ingredient)
    # get :show, :recipe => ingredient.recipe, :id => ingredient
    get :show, :id => ingredient
    assert_template 'show'
  end
  
  # TODO: Decide whether we want to nest ingredient under recipe
  # def test_show_without_recipe
  #   ingredient = Factory.create(:ingredient)
  #   get :show, :id => ingredient
  #   assert_response :error
  # end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Ingredient.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Ingredient.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to ingredient_url(assigns(:ingredient))
  end
  
  def test_edit
    get :edit, :id => Ingredient.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Ingredient.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Ingredient.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Ingredient.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Ingredient.first
    assert_redirected_to ingredient_url(assigns(:ingredient))
  end
  
  def test_destroy
    ingredient = Ingredient.first
    delete :destroy, :id => ingredient
    assert_redirected_to ingredients_url
    assert !Ingredient.exists?(ingredient.id)
  end
end
