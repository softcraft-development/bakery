require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Factory.build(:recipe).valid?
  end
  
  def test_name_required
    recipe = Factory.build(:recipe, :name => nil)
    assert !Recipe.new.valid?
  end

  def test_add_ingredients
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
end
