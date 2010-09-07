require 'test_helper'
require 'application_helper'

class RecipesHelperTest < ActionView::TestCase
  include ApplicationHelper
  
  def test_food_autocomplete_properties_purchase_amount_nil
    food = Factory.create(:food)
    food.purchase_amount = nil
    assert_equal "N/A", food_autocomplete_properties(food)[:purchase_amount]
  end
  
  def test_food_autocomplete_properties_purchase_amount_not_nil
    food = Factory.create(:food)
    food.purchase_amount = "not nil"
    assert_equal "not nil", food_autocomplete_properties(food)[:purchase_amount]
  end
  
  def test_food_autocomplete_properties_purchase_cost_nil
    food = Factory.create(:food)
    food.purchase_cost = nil
    assert_equal "$N/A", food_autocomplete_properties(food)[:purchase_cost]
  end
  
  def test_food_autocomplete_properties_purchase_cost_not_nil
    food = Factory.create(:food)
    food.purchase_cost = Factory.next(:prime)
    assert_equal number_to_currency(food.purchase_cost), food_autocomplete_properties(food)[:purchase_cost]
  end
end
