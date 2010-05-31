require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  def test_admin_site
    assert Ability.new(Factory.build(:admin)).can(:manage, :site)
  end
  
  def test_non_admin_site
    assert Ability.new(Factory.build(:user)).cannot(:manage, :site)
  end
end