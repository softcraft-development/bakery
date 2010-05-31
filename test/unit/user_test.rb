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
end
