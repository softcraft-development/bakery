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
end
