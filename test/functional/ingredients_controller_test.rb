require 'test_helper'

class IngredientsControllerTest < ActionController::TestCase
  def test_index
    get :index, :recipe_id => Factory.create(:recipe).id
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Factory.create(:ingredient)
    assert_template 'show'
  end
  
  def test_new
    get :new, :recipe_id => Factory.create(:recipe).id
    assert_template 'new'
  end
  
  def test_create_invalid
    Ingredient.any_instance.stubs(:valid?).returns(false)
    post :create, :recipe_id => Factory.create(:recipe).id
    assert_template 'new'
  end
  
  def test_create_valid
    Ingredient.any_instance.stubs(:valid?).returns(true)
    post :create, :recipe_id => Factory.create(:recipe).id
    assert_redirected_to ingredient_url(assigns(:ingredient))
  end
  
  def test_edit
    get :edit, :id => Factory.create(:ingredient)
    assert_template 'edit'
  end
  
  def test_update_invalid
    ingredient = Factory.create(:ingredient)
    Ingredient.any_instance.stubs(:valid?).returns(false)
    put :update, :id => ingredient
    assert_template 'edit'
  end
  
  def test_update_valid
    ingredient = Factory.create(:ingredient)
    Ingredient.any_instance.stubs(:valid?).returns(true)
    put :update, :id => ingredient
    assert_redirected_to ingredient_url(assigns(:ingredient))
  end
  
  def test_destroy
    ingredient = Factory.create(:ingredient)
    delete :destroy, :id => ingredient
    assert_redirected_to recipe_ingredients_url(ingredient.recipe)
    assert !Ingredient.exists?(ingredient.id)
  end
end
