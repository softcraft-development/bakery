require 'test_helper'

class RecipesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Factory.create(:recipe)
    assert_template 'show'
  end
  
  def test_show_by_friendly_id
    get :show, :id => Factory.create(:recipe).to_param
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  #TODO: reenable this once we can figure out how to remove any_instance
  # def test_create_invalid
  #   Recipe.any_instance.stubs(:valid?).returns(false)
  #   post :create
  #   assert_template 'new'
  # end
  
  def test_create_valid
    recipe = Factory.build(:recipe)
    post :create, :recipe => { :name => recipe.name }
    assert_not_nil assigns(:recipe).id
  end
  
  def test_create_redirects_to_show
    recipe = Factory.build(:recipe)
    post :create, :recipe => { :name => recipe.name }
    assigned = assigns(:recipe)
    assert_redirected_to recipe_url(assigned) if assigned.id != nil
  end
  
  def test_create_with_ingredients
    ingredient = Factory.build(:ingredient)
    post :create, :recipe=> { 
      :name=> ingredient.recipe.name,
      :ingredients_attributes=>{
          "0"=>{
              :name=>ingredient.name,
              :amount=>ingredient.amount
          }
      }
    }
    recipe = assigns(:recipe)
    assert_not_nil recipe.ingredients[0].id
  end
  
  def test_edit
    get :edit, :id => Factory.create(:recipe)
    assert_template 'edit'
  end

  #TODO: reenable this once we can figure out how to remove any_instance  
  # def test_update_invalid
  #   recipe = Factory.create(:recipe)
  #   Recipe.any_instance.stubs(:valid?).returns(false)
  #   put :update, :id => recipe
  #   assert_template 'edit'
  # end
  
  def test_update_valid
    #TODO: reenable this once we can figure out how to remove any_instance
    # Recipe.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Factory.create(:recipe)
    assert_redirected_to recipe_url(assigns(:recipe))
  end
  
  def test_update_nested
    ingredient = Factory.create(:ingredient)
    put :update, 
      :id=>ingredient.recipe.friendly_id,
      :recipe=> { 
        :name=> ingredient.recipe.name,
        :ingredients_attributes=>{
            "0"=>{
                :name=>ingredient.name,
                :amount=>ingredient.amount,
                :"id"=>ingredient.id,
                :_destroy=>"1"
            }
        }
      }
    recipe = Recipe.find(ingredient.recipe.id)
    assert_equal 0, recipe.ingredients.size
  end
  
  def test_destroy
    recipe = Factory.create(:recipe)
    delete :destroy, :id => recipe
    assert_redirected_to recipes_url
    assert !Recipe.exists?(recipe.id)
  end
end
