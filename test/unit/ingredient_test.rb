require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Factory.build(:ingredient).valid?
  end
  
  # TODO: Re-enable this when the validation is replaced
  # def test_should_require_recipe
  #     assert !Factory.build(:ingredient, :recipe => nil).valid?
  #   end  

  def test_amount_required
    assert !Factory.build(:ingredient, :amount => nil).valid?
  end  

  def test_amount_is_a_unit
    assert !Factory.build(:ingredient, :amount => "this is not a valid amount").valid?
  end

  def test_sort_order_required
    assert !Factory.build(:ingredient, :sort_order => nil).valid?
  end  

  def test_sort_order_is_a_number
    assert !Factory.build(:ingredient, :sort_order => "this is not a valid sort order").valid?
  end

  def test_sort_order_is_a_floating_point_number
    assert Factory.build(:ingredient, :sort_order => -1.5).valid?
  end
  
  def test_default_sort_order
    recipe = Factory.create(:recipe)
    a = Factory.create(:ingredient, :recipe => recipe, :sort_order => 2 )
    b = Factory.create(:ingredient, :recipe => recipe, :sort_order => 1 )
    c = Factory.create(:ingredient, :recipe => recipe, :sort_order => 1.5 )
    recipe.reload
    assert_equal [b,c,a], recipe.ingredients, 
      recipe.ingredients.inject("Recipe ingredients are not in correct sort order: ") { |result, x| result +=  "#{x.sort_order}, " }
  end
  
  def test_scale
    ingredient = Factory.build(:scalable_ingredient)
    target = Factory.next(:prime)
    scaled = ingredient.scale(target)
    assert_equal ingredient.amount.unit * target, scaled.amount.unit
  end

  def test_scaled_cant_be_saved
    ingredient = Factory.create(:scalable_ingredient)
    scaled = ingredient.scale(Factory.next(:prime))
    assert_raise_kind_of Exception do
      scaled.save!
    end
  end

  def test_scaled_cant_be_modified
    scaled = Factory.build(:scalable_ingredient).scale(Factory.next(:prime))
    assert_raises TypeError do
      scaled.sort_order = scaled.sort_order + 1
    end
  end
  
  def test_scaled_has_same_food
    ingredient = Factory.build(:scalable_ingredient)
    scaled = ingredient.scale(Factory.next(:prime))
    assert_equal ingredient.food, scaled.food
  end

  def test_scaled_has_same_id
    ingredient = Factory.create(:scalable_ingredient)
    scaled = ingredient.scale(Factory.next(:prime))
    assert_equal ingredient.id, scaled.id
  end

  def test_scaled_has_no_recipe
    ingredient = Factory.build(:scalable_ingredient)
    scaled = ingredient.scale(Factory.next(:prime))
    assert_nil scaled.recipe
  end
  
  def test_cost
    ingredient = Factory.build(:costable_ingredient)
    food = ingredient.food
    assert_equal food.cost(ingredient.amount), ingredient.cost
  end
  
  def test_accepts_nested_foods
    recipe = Factory.create(:recipe)
    params = {
        :amount => "3 g",
        :food_attributes => {
          :name => "Nested Food",
          :user_id => recipe.user.id
        }
    }
    ingredient = Ingredient.create(params)
    assert_equal "Nested Food", ingredient.food.name
    assert_equal recipe.user, ingredient.food.user
    assert_equal "3 g", ingredient.amount
    assert !ingredient.food.new_record?
    assert !ingredient.new_record?
  end
  
  def test_factory_built_ingredient_recipe_has_ingredient
    ingredient = Factory.create(:ingredient)
    recipe = ingredient.recipe
    assert_equal 1, recipe.ingredients.size
    assert_equal ingredient, recipe.ingredients[0]
  end
end
