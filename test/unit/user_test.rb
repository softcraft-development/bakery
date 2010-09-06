require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def test_should_be_valid
    user = Factory.build(:user)
    assert user.valid?
  end
  
  def test_user_email_required
    assert !Factory.build(:user, :email => nil).valid?
  end
  
  def test_role_retrieval
    user = Factory.build(:user)
    test_roles = :test1, :test2
    user.load_roles!(test_roles.join(" "))
    assert_equal 0, (user.roles - test_roles).size
  end
  
  def test_role_set
    user = Factory.build(:user)
    test_roles = :test1, :test2
    user.roles = test_roles
    role_list = user.set_role_list!
    assert_equal test_roles.join(" "), role_list
  end
  
  def test_role_set_on_save
    user = Factory.build(:user)
    test_roles = :test1, :test2
    user.roles = test_roles
    user.save!
    assert_equal test_roles.join(" "), user.send(:role_list)
  end

  def test_role_set_with_non_symbols
    user = Factory.build(:user)
    test_roles = :test1, :test2
    user.roles = test_roles + ["test3", 4]
    role_list = user.set_role_list!
    assert_equal test_roles.join(" "), role_list
  end
  
  def test_role_clear
    user = Factory.build(:user)
    user.roles.clear
    role_list = user.set_role_list!
    assert_equal "", role_list
  end
  
  def test_get_role_token_used_in_role_list
    role_token = User.get_role_token(:test)
    user = Factory.build(:user)
    user.load_roles! role_token
    assert_not_nil user.roles.find(:test)
  end
  
  def test_get_role_used_in_role_list
    user = Factory.build(:user)
    role_list = user.set_role_list! [:test]
    role = User.get_role(role_list)
    assert_equal :test, role
  end
  
  def test_admins
    user = Factory.create(:admin)
    assert User.admins.all.include?(user)
  end

  def test_having_role_does_not_match_roles_with_subset_names
    user = Factory.create(:user, :roles => [:aaabbbccc])
    assert !User.having_role(:bbb).all.include?(user)
  end
  
  def test_having_role
    user = Factory.create(:user, :roles => [:test])
    assert User.having_role(:test).all.include?(user)
  end
  
  # I was suspicious that the include? in the above test may not be correct
  def test_include
    user = Factory.create(:user)
    assert User.all.include?(user)
  end

  def test_recipes
    recipe = Factory.create(:recipe)
    user = recipe.user
    assert_equal [recipe], user.recipes
  end
  
  def test_foods
    food = Factory.create(:user_food)
    user = food.user
    for_user = user.foods
        
    assert for_user.include?(food)
  end  
end
