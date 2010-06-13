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
    assert Ingredient.exists? ingredient.id
    recipe.destroy
    assert !Ingredient.exists?(ingredient.id)
  end
  
  def test_accept_nested_ingredients
    params = { 
      :name => "test_accept_nested_ingredients",
      :yield => Factory.next(:prime),
      :user => Factory.create(:user),
      :ingredients_attributes => [
        {:amount => "1 pound", :name => "flour"},
        {:amount => "1 pound", :name => "sugar"},
        {:amount => "1 pound", :name => "eggs"},
        {:amount => "1 pound", :name => "butter"},
      ]
    }
    recipe = Recipe.create(params)
    assert_equal 4, recipe.ingredients.size
  end
  
  def test_yield_string_no_decimals
    recipe = Factory.build(:recipe)
    recipe.yield = 123.0
    assert "123", recipe.yield_string
  end

  def test_yield_string_decimals
    recipe = Factory.build(:recipe)
    recipe.yield = 123.4
    assert "123.4", recipe.yield_string
  end

  def test_yield_string_=
    recipe = Factory.build(:recipe)
    recipe.yield_string = "123.4"
    assert 123.4, recipe.yield
  end

  def test_yield_string_bad=
    recipe = Factory.build(:recipe)
    assert_raises ArgumentError do
      recipe.yield_string = "not a valid number"
    end
  end
  
  def test_total_yield_unit_size
    recipe = Factory.build(:recipe)
    recipe.yield = 3
    recipe.yield_size = "5 kg"
    assert_equal "15 kg".unit, recipe.total_yield
  end

  def test_total_yield_unknown_unit_size
    recipe = Factory.build(:recipe)
    recipe.yield = 3
    recipe.yield_size = "5 foos"
    assert_equal 3, recipe.total_yield
  end

  def test_total_yield_nil_unit_size
    recipe = Factory.build(:recipe)
    recipe.yield = 3
    recipe.yield_size = nil
    assert_equal 3, recipe.total_yield
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
      recipe.scale(3)
    end
  end
  
  def test_scale_results_frozen
    recipe = Factory.build(:scalable_recipe)
    scaled = recipe.scale(recipe.yield * 3)
    assert scaled.frozen?
  end

  def test_scale_yield
    recipe = Factory.build(:scalable_recipe)
    scaled = recipe.scale(recipe.yield * 3)
    assert_equal recipe.yield * 3, scaled.yield
  end
  
  def test_scale_yield_size
    recipe = Factory.build(:scalable_recipe)
    scaled = recipe.scale(recipe.yield * 3)
    assert_equal recipe.yield_size, scaled.yield_size
  end

  def test_scale_ingredient_amount
    recipe = Factory.build(:scalable_recipe)
    scaled = recipe.scale(recipe.yield * 3)
    assert_equal recipe.ingredients.first.amount.unit * 3, scaled.ingredients.first.amount.unit
  end
  
  def test_scaled_cant_be_saved
    recipe = Factory.create(:scalable_recipe)
    scaled = recipe.scale(3)
    assert_raise_kind_of Exception do
      scaled.save!
    end
  end

  def test_scaled_cant_be_modified
    scaled = Factory.build(:scalable_recipe).scale(2)
    assert_raise TypeError do
      scaled.name = "New Name"
    end
  end  

  def test_scaled_has_same_name
    recipe = Factory.build(:scalable_recipe)
    scaled = recipe.scale(3)
    assert_equal recipe.name, scaled.name
  end

  def test_scaled_has_same_id
    recipe = Factory.create(:scalable_recipe)
    scaled = recipe.scale(3)
    assert_equal recipe.id, scaled.id
  end
  
  def test_scaled_has_same_param
    recipe = Factory.create(:scalable_recipe)
    scaled = recipe.scale(3)
    assert_equal recipe.to_param, scaled.to_param
  end
  
  def test_scaled_ingredients_have_recipe
    recipe = Factory.create(:scalable_recipe)
    scaled = recipe.scale(3)
    assert_equal scaled, scaled.ingredients.first.recipe
  end
  
  def test_scale_total_yield
    recipe = Factory.build(:scalable_recipe)
    scaled = recipe.scale(recipe.yield * 3, recipe.yield_size.unit * 5)
    assert_equal recipe.total_yield.unit * 15, scaled.total_yield.unit
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
    recipe.ingredients.first.purchase_cost = nil
    assert_equal nil, recipe.cost
  end
  
  def test_recipe_unit_cost_valid
    recipe = Factory.build(:costable_recipe)
    total = recipe.ingredients.inject(0) { |t,ingredient| t + ingredient.cost }
    assert_equal total / recipe.yield, recipe.unit_cost
  end  

  def test_recipe_unit_cost_unknown
    recipe = Factory.build(:costable_recipe)
    recipe.ingredients.first.purchase_cost = nil
    assert_equal nil, recipe.unit_cost
  end  
end
