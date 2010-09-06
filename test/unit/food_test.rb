require 'test_helper'

class FoodTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Factory.build(:food).valid?
  end
  
  def test_name_required
    assert !Factory.build(:food, :name => nil).valid?
  end  
  
  def test_cost_unknown_purchase_amount
    food = Factory.build(:food)
    food.purchase_amount = "#{Factory.next(:prime)} lbs"
    assert_nil food.cost("#{Factory.next(:prime)} g")
  end
  
  def test_cost_unknown_purchase_cost
    food = Factory.build(:food)
    food.purchase_cost = Factory.next(:prime)
    assert_nil food.cost("#{Factory.next(:prime)} g")
  end
  
  def test_cost_invalid_units
    food = Factory.build(:food)
    food.purchase_amount = "#{Factory.next(:prime)} cups"
    food.purchase_cost = Factory.next(:prime)
    assert_nil food.cost("#{Factory.next(:prime)} kg")
  end

  def test_cost_valid
    food = Factory.build(:food)
    target_amount = Factory.next(:prime)
    target_purchase_amount = Factory.next(:prime)
    food.purchase_amount = "#{target_purchase_amount} kg"
    food.purchase_cost = Factory.next(:prime)
    target = (target_amount / target_purchase_amount * food.purchase_cost)
    assert_float_equal target, food.cost("#{target_amount} kg")
  end
  
  def test_cost_no_purchase_amount
    food = Factory.build(:food)
    food.purchase_amount = "0"
    food.purchase_cost = Factory.next(:prime)
    assert_float_equal 0, food.cost("#{Factory.next(:prime)} kg")
  end
  
  def test_cost_different_units
    food = Factory.build(:food)
    target_amount = Factory.next(:prime)
    target_purchase_amount = Factory.next(:prime)
    food.purchase_amount = "#{target_purchase_amount} kg"
    food.purchase_cost = Factory.next(:prime)
    target = (target_amount / 1000 / target_purchase_amount * food.purchase_cost)
    assert_float_equal target, food.cost("#{target_amount} g")
  end
  
  def test_costable_food_has_cost
    food = Factory.build(:costable_food)
    assert_not_nil food.cost("#{Factory.next(:prime)} kg")
  end
  
  def test_with_name
    food = Factory.build(:food)
    food.name = "Test Food #{Time.now.to_i}"
    food.save!
    found = Food.with_name(food.name)
    
    assert found.include?(food)
  end
  
  def test_food_for_user_with_name
    food = Factory.build(:user_food)
    food.name = "Test Food #{Time.now.to_i}"
    food.save!
    
    # Food, same name, not for user
    another_food = Factory.build(:food)
    another_food.user = nil
    another_food.name = food.name
    another_food.save!
    
    found = food.user.foods.with_name(food.name)
    
    assert !found.include?(another_food)
  end
end
