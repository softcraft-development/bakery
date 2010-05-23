require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Factory.build(:ingredient).valid?
  end
  
  def test_should_require_recipe
    assert !Factory.build(:ingredient, :recipe => nil).valid?
  end
end
