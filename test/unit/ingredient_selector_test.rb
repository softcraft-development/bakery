require 'test_helper'

class IngredientSelectorTest < ActiveSupport::TestCase
  def test_to_ingredient_existing_ingredient
    ingredient = Factory.create(:ingredient)
    selector = IngredientSelector.new
    selector.ingredient = ingredient
    built = selector.to_ingredient
    
    assert_same ingredient, built
  end
  
  def test_to_ingredient_recipe
    selector = IngredientSelector.new
    selector.recipe = Factory.create(:recipe)

    assert_equal selector.recipe, selector.to_ingredient.recipe
  end

  def test_to_ingredient_food
    selector = IngredientSelector.new
    selector.food = Factory.create(:food)

    assert_equal selector.food, selector.to_ingredient.food
  end
  
  def test_to_ingredient_food_by_name
    selector = IngredientSelector.new
    food = Factory.create(:user_food)
    selector.user = food.user
    selector.food_name = food.name
    built = selector.to_ingredient

    assert_equal food, built.food
  end
  
  def test_to_ingredient_amount
    selector = IngredientSelector.new
    selector.amount = Factory.next(:prime)
    built = selector.to_ingredient
    
    assert_equal selector.amount, built.amount
  end
  
  def test_food_for_name_found
    target = Factory.create(:user_food)
    selector = IngredientSelector.new
    selector.food_name = target.name
    selector.user = target.user
    for_name = selector.food_for_name
    
    assert_equal target, for_name
  end
  
  def test_food_for_name_not_found
    target = Factory.create(:user_food)
    selector = IngredientSelector.new
    selector.food_name = target.name + " does not exist"
    selector.user = target.user
    for_name = selector.food_for_name
    
    assert_nil for_name
  end
  
  def test_food_for_name_no_user
    food = Factory.create(:user_food)
    selector = IngredientSelector.new
    selector.food_name = food.name
    # Do not set the user on the selector
    
    assert_nil selector.food_for_name
  end
end