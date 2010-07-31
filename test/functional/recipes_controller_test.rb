require 'test_helper'

class RecipesControllerTest < ActionController::TestCase
  def setup
    sign_in Factory.create(:user)
  end
  
  def test_index_template
    get :index
    assert_template 'index'
  end
  
  def test_index_only_users_recipes
    recipe = Factory.create(:recipe)
    sign_in recipe.user
    another_recipe = Factory.create(:recipe) # with a different user
    get :index
    assert_equal [recipe], assigns(:recipes)
  end
  
  def test_show_template
    get :show, :id => Factory.create(:scalable_recipe)
    assert_template 'show'
  end
  
  def test_show_success
    get :show, :id => Factory.create(:scalable_recipe).id
    assert_response :success
  end
  
  def test_show_assigns_recipe
    recipe =  Factory.create(:scalable_recipe)
    get :show, :id => recipe
    assert_equal recipe, assigns(:recipe)
  end
  
  def test_show_by_friendly_id
    get :show, :id => Factory.create(:scalable_recipe).to_param
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
    post :create, :recipe => Factory.attributes_for(:recipe)
    assert_not_nil assigns(:recipe).id
  end
  
  def test_create_redirects_to_show
    post :create, :recipe => Factory.attributes_for(:recipe)
    assigned = assigns(:recipe)
    assert_redirected_to recipe_url(assigned) if assigned.id != nil
  end
  
  def test_create_with_ingredients
    params = 
    post :create, :recipe => Factory.attributes_for(:recipe).merge({
      :ingredients_attributes => 
        [Factory.attributes_for(:ingredient)]
      })
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
  
  # def test_update_nested
  #     ingredient = Factory.create(:ingredient)
  #     put :update, 
  #       :id=>ingredient.recipe.friendly_id,
  #       :recipe=> { 
  #         :name=> ingredient.recipe.name,
  #         :ingredients_attributes=>{
  #             "0"=>{
  #                 # :name=>ingredient.name,
  #                 :amount=>ingredient.amount,
  #                 :"id"=>ingredient.id,
  #                 :food_id => ingredient.food.id,
  #                 :_destroy=>"1"
  #             }
  #         }
  #       }
  #     recipe = Recipe.find(ingredient.recipe.id)
  #     assert_equal 0, recipe.ingredients.size
  #   end
  
  def test_update_name
    recipe = Factory.create(:recipe)
    put :update, 
    :id => recipe.id,
    :recipe => {
      :name => "test_update new name"
    }
    recipe.reload
    assert_equal "test_update new name", recipe.name
  end
  
  def test_update_success
    ingredient = Factory.create(:ingredient)
    recipe = ingredient.recipe
    original_amount = ingredient.amount
    
    params = {
      :ingredient_attributes => [ {
        :id => ingredient.id,
        :amount => original_amount * 3
      } ]
    }
    
    put :update, 
      :id => recipe.id,
      :recipe => params

    assert_redirected_to :controller => "recipes", :action => "show", :id => recipe.friendly_id
  end
  
  def test_update_nested
    # ingredient = Factory.create(:ingredient)
    # recipe = ingredient.recipe
    recipe = Recipe.create(:name=>"test recipe", :yield => "1", :user => Factory.create(:user))
    ingredient = Ingredient.create(:food => Factory.create(:food), :amount => 11, :recipe => recipe)
    recipe.ingredients << ingredient

    original_amount = ingredient.amount.unit
    target_amount = original_amount.unit * 3
    
    params = ingredient.get_update_parameters(target_amount)
            
    put :update, 
      :id => recipe.id,
      :recipe => params
    recipe.reload
    assert_equal target_amount, recipe.ingredients[0].amount.unit
  end
  
  def test_destroy
    recipe = Factory.create(:recipe)
    delete :destroy, :id => recipe
    assert_redirected_to recipes_url
    assert !Recipe.exists?(recipe.id)
  end
end
