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
end
