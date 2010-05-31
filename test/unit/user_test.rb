require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def test_should_be_valid
    user = Factory.build(:user)
    assert user.valid?
  end
  
  def test_user_email_required
    assert !Factory.build(:user, :email => nil).valid?
  end
end
