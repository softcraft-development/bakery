require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Factory.build(:ingredient).valid?
  end
  
  # TODO: Re-enable this when the validation is replaced
  # def test_should_require_recipe
  #     assert !Factory.build(:ingredient, :recipe => nil).valid?
  #   end  
  
  def test_name_required
    assert !Factory.build(:ingredient, :name => nil).valid?
  end  

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
    assert_equal [b,c,a], recipe.ingredients, 
      recipe.ingredients.inject("Recipe ingredients are not in correct sort order: ") { |result, x| result +=  "#{x.sort_order}, " }
  end
  
  def test_scale
    ingredient = Factory.build(:scalable_ingredient)
    scaled = ingredient.scale(2)
    assert_equal ingredient.amount.unit * 2, scaled.amount.unit
  end

  def test_scaled_cant_be_saved
    ingredient = Factory.create(:scalable_ingredient)
    scaled = ingredient.scale(2)
    assert_raise_kind_of Exception do
      scaled.save!
    end
  end

  def test_scaled_cant_be_modified
    scaled = Factory.build(:scalable_ingredient).scale(2)
    assert_raises TypeError do
      scaled.name = "New Name"
    end
  end
  
  def test_scaled_has_same_name
    ingredient = Factory.build(:scalable_ingredient)
    scaled = ingredient.scale(2)
    assert_equal ingredient.name, scaled.name
  end

  def test_scaled_has_same_id
    ingredient = Factory.create(:scalable_ingredient)
    scaled = ingredient.scale(2)
    assert_equal ingredient.id, scaled.id
  end

  def test_scaled_has_no_recipe
    ingredient = Factory.build(:scalable_ingredient)
    scaled = ingredient.scale(2)
    assert_nil scaled.recipe
  end
  
  def test_cost_unknown_purchase_amount
    ingredient = Factory.build(:ingredient)
    ingredient.purchase_amount = "3 lbs"
    assert_nil ingredient.cost
  end
  
  def test_cost_unknown_purchase_cost
    ingredient = Factory.build(:ingredient)
    ingredient.purchase_cost = 3
    assert_nil ingredient.cost
  end
  
  def test_cost_invalid_units
    ingredient = Factory.build(:ingredient)
    ingredient.amount = "3 kg"
    ingredient.purchase_amount = "5 cups"
    ingredient.purchase_cost = "7"
    assert_nil ingredient.cost
  end

  def test_cost_valid
    ingredient = Factory.build(:ingredient)
    ingredient.amount = "3 kg"
    ingredient.purchase_amount = "5 kg"
    ingredient.purchase_cost = 7
    assert_equal (3 / 5 * 7), ingredient.cost
  end
end
