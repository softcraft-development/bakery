require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Factory.build(:recipe).valid?
  end
  
  def test_name_required
    recipe = Factory.build(:recipe, :name => nil)
    assert !Recipe.new.valid?
  end

  def test_add_ingredients_without_intermediate_save
    recipe = Factory.build(:recipe)
    ingredient = Factory.build(:ingredient, :recipe => nil)
    recipe.ingredients << ingredient
    recipe.save!
    assert Recipe.find(recipe.id).ingredients.include?(Ingredient.find(ingredient.id))
  end

  def test_add_ingredients_with_intermediate_save
    recipe = Factory.build(:recipe)
    recipe.save!
    ingredient = Factory.build(:ingredient, :recipe => nil)
    recipe.ingredients << ingredient
    assert Recipe.find(recipe.id).ingredients.include?(Ingredient.find(ingredient.id))
  end
  
  def test_to_param_is_friendly_id
    recipe = Factory.create(:recipe)
    assert_equal recipe.friendly_id, recipe.to_param
  end
  
  def test_find_by_friendly_id
    recipe = Factory.create(:recipe)
    found = Recipe.find(recipe.to_param)
    assert_equal recipe, found
  end
  
  def test_destroy_ingredients
    recipe = Factory.create(:recipe)
    ingredient = Factory.create(:ingredient, :recipe => recipe)
    recipe.reload
    assert Ingredient.exists? ingredient.id
    assert_equal recipe, ingredient.recipe
    assert_equal ingredient, recipe.ingredients[0]
    recipe.destroy
    assert !Ingredient.exists?(ingredient.id)
  end
  
  def test_accept_nested_ingredients
    user = Factory.create(:user)
    params = { 
      :name => "test_accept_nested_ingredients",
      :yield => Factory.next(:prime),
      :user => user,
      :ingredients_attributes => [
        ingredient_parameters("flour", user),
        ingredient_parameters("sugar", user),
        ingredient_parameters("eggs", user),
        ingredient_parameters("butter", user),
      ]
    }
    recipe = Recipe.create(params)
    assert_equal 4, recipe.ingredients.size
    recipe.ingredients.each do |ingredient|
      assert !ingredient.new_record?
      assert_not_nil ingredient.food
      assert !ingredient.food.new_record?
    end
  end
  
  def test_update_attributes_recipe
    recipe = Factory.create(:recipe)
    new_name = "test_update_attributes_recipe"
    params = {
      :name => new_name
    }
    recipe.update_attributes(params)
    assert_equal new_name, recipe.name
  end
  
  def test_update_attributes_ingredients
    ingredient = Factory.create(:ingredient)
    ingredient = Ingredient.find(ingredient.id)
    recipe = ingredient.recipe
    original_amount = ingredient.amount.unit
    target_amount = original_amount.unit * 3
    params = ingredient.get_update_parameters(target_amount)
    recipe.ingredients.to_s
    recipe.update_attributes(params)
    ingredient = Ingredient.find(ingredient.id)
    recipe = ingredient.recipe
    assert_equal target_amount, ingredient.amount.unit
  end
  
  def test_pushes_user_to_foods
    params = { 
      :name => "test_pushes_user_to_foods",
      :yield => Factory.next(:prime),
      :user => Factory.create(:user),
      :ingredients_attributes => [
        {
            :amount => "#{Factory.next(:prime)} pound", 
            :food_attributes => {
              :name => "test_pushes_user_to_foods",
            } 
        }
      ]
    }
    recipe = Recipe.create(params)
    assert_equal recipe.user, recipe.ingredients.first.food.user
  end
  
  def ingredient_parameters(food_name, user)
    return {
        :amount => "#{Factory.next(:prime)} pound", 
        :food_attributes => {
          :name => food_name,
          :user => user
        } 
    }
  end
  
  def test_yield_string_no_decimals
    recipe = Factory.build(:recipe)
    target = Factory.next(:prime)
    recipe.yield = target
    assert target.to_s, recipe.yield_string
  end

  def test_yield_string_decimals
    recipe = Factory.build(:recipe)
    target = Factory.next(:prime) + 0.1
    recipe.yield = target
    assert target.to_s, recipe.yield_string
  end

  def test_yield_string_=
    recipe = Factory.build(:recipe)
    target = Factory.next(:prime) + 0.1
    recipe.yield_string = target.to_s
    assert target, recipe.yield
  end

  def test_yield_string_bad=
    recipe = Factory.build(:recipe)
    assert_raises ArgumentError do
      recipe.yield_string = "not a valid number"
    end
  end
  
  def test_total_yield_unit_size
    recipe = Factory.build(:recipe)
    recipe.yield = Factory.next(:prime)
    target_yield_size = Factory.next(:prime)
    recipe.yield_size = "#{target_yield_size} kg"
    target = recipe.yield * target_yield_size
    assert_equal "#{target} kg".unit, recipe.total_yield
  end

  def test_total_yield_unknown_unit_size
    recipe = Factory.build(:recipe)
    recipe.yield = Factory.next(:prime)
    recipe.yield_size = "#{Factory.next(:prime)} foos"
    assert_equal recipe.yield, recipe.total_yield
  end

  def test_total_yield_nil_unit_size
    recipe = Factory.build(:recipe)
    recipe.yield = Factory.next(:prime)
    recipe.yield_size = nil
    assert_equal recipe.yield, recipe.total_yield
  end
  
  def test_scaleable_recipe_has_ingredient
    recipe = Factory.build(:scalable_recipe)
    assert_equal 1, recipe.ingredients.size
  end
  
  def test_scaleable_recipe_ingredients_does_not_infinite_loop
    recipe = Factory.build(:scalable_recipe)
    has_any = false
    assert_completes_in 4 do
      recipe.ingredients.each { |ingredient|
        assert ingredient
        has_any = true
      }
    end
    assert has_any, :message => " Was not able to get ingredients."
  end
  
  def test_scale_does_not_infinite_loop
    recipe = Factory.build(:scalable_recipe)
    assert_completes_in 4 do
      recipe.scale(Factory.next(:prime))
    end
  end
  
  def test_scale_results_frozen
    recipe = Factory.build(:scalable_recipe)
    scaled = recipe.scale(recipe.yield * Factory.next(:prime))
    assert scaled.frozen?
  end

  def test_scale_yield
    recipe = Factory.build(:scalable_recipe)
    target = Factory.next(:prime)
    scaled = recipe.scale(target)
    assert_equal target, scaled.yield
  end
  
  def test_scale_yield_size
    recipe = Factory.build(:scalable_recipe)
    scaled = recipe.scale(Factory.next(:prime))
    assert_equal recipe.yield_size, scaled.yield_size
  end

  def test_scale_ingredient_amount
    recipe = Factory.build(:scalable_recipe)
    target= Factory.next(:prime)
    scaled = recipe.scale(recipe.yield * target)
    assert_equal recipe.ingredients.first.amount.unit * target, scaled.ingredients.first.amount.unit
  end
  
  def test_scaled_cant_be_saved
    recipe = Factory.create(:scalable_recipe)
    scaled = recipe.scale(Factory.next(:prime))
    assert_raise_kind_of Exception do
      scaled.save!
    end
  end

  def test_scaled_cant_be_modified
    scaled = Factory.build(:scalable_recipe).scale(Factory.next(:prime))
    assert_raise TypeError do
      scaled.name = "New Name"
    end
  end  

  def test_scaled_has_same_name
    recipe = Factory.build(:scalable_recipe)
    scaled = recipe.scale(Factory.next(:prime))
    assert_equal recipe.name, scaled.name
  end

  def test_scaled_has_same_id
    recipe = Factory.create(:scalable_recipe)
    scaled = recipe.scale(Factory.next(:prime))
    assert_equal recipe.id, scaled.id
  end
  
  def test_scaled_has_same_param
    recipe = Factory.create(:scalable_recipe)
    scaled = recipe.scale(Factory.next(:prime))
    assert_equal recipe.to_param, scaled.to_param
  end
  
  def test_scaled_ingredients_have_recipe
    recipe = Factory.create(:scalable_recipe)
    scaled = recipe.scale(Factory.next(:prime))
    assert_equal scaled, scaled.ingredients.first.recipe
  end
  
  def test_scale_total_yield
    recipe = Factory.build(:scalable_recipe)
    target_yield = Factory.next(:prime)
    target_yield_size = Factory.next(:prime)
    scaled = recipe.scale(target_yield, target_yield_size)
    assert_equal target_yield * target_yield_size, scaled.total_yield.unit
  end
  
  def test_user_can_manage_own_recipe
    recipe = Factory.build(:recipe)    
    assert Ability.new(recipe.user).can?(:manage, recipe)
  end
  
  def test_user_cannot_manage_other_recipe
    recipe = Factory.build(:recipe)
    some_other_user = Factory.build(:user)
    assert Ability.new(some_other_user).cannot?(:manage, recipe)
  end

  def test_user_can_create_recipe
    assert Ability.new(Factory.build(:user)).can?(:create, Recipe.new)
  end
  
  def test_costable_recipe_has_ingredients
    recipe = Factory.build(:costable_recipe)
    assert_not_equal 0, recipe.ingredients
  end
  
  def test_costable_recipe_has_all_costable_ingredients
    recipe = Factory.build(:costable_recipe)
    assert_all recipe.ingredients do |ingredient|
      assert_not_nil ingredient.cost
    end
  end
  
  def test_recipe_cost_valid
    recipe = Factory.build(:costable_recipe)
    total = recipe.ingredients.inject(0) { |t,ingredient| t + ingredient.cost }
    recipe_cost = recipe.cost
    assert_equal total, recipe_cost
  end

  def test_recipe_cost_unknown
    recipe = Factory.build(:costable_recipe)
    recipe.ingredients.first.food.purchase_cost = nil
    assert_equal nil, recipe.cost
  end
  
  def test_recipe_unit_cost_valid
    recipe = Factory.build(:costable_recipe)
    total = recipe.ingredients.inject(0) { |t,ingredient| t + ingredient.cost }
    assert_equal total / recipe.yield, recipe.unit_cost
  end  

  def test_recipe_unit_cost_unknown
    recipe = Factory.build(:costable_recipe)
    recipe.ingredients.first.food.purchase_cost = nil
    assert_equal nil, recipe.unit_cost
  end  
  
  def test_recipe_ingredient_loading_with_callback
    recipe = Recipe.new({
      :name => "Test Recipe",
      :user => Factory.create(:user),
      :yield => Factory.next(:prime)
    })
    recipe.save!
    assert_equal [], recipe.ingredients

    ingredient = Ingredient.new({
      :food => Factory.create(:food),
      :amount => Factory.next(:prime)
    })
    ingredient.recipe = recipe
    ingredient.save!
    # ingredient.recipe = recipe
    # recipe.ingredients << ingredient
    # recipe.save!
    # recipe.reload
    recipe = Recipe.find(recipe.id)
    recipe.ingredients.to_s
    # assert_equal [ingredient], recipe.ingredients

    target_amount = ingredient.amount.unit * 3
    params = ingredient.get_update_parameters(target_amount)
    recipe.update_attributes(params)
    assert_equal target_amount, recipe.ingredients[0].amount.unit
  end
end
