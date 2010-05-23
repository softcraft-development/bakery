require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Factory.build(:recipe).valid?
  end
  
  def test_name_required
    recipe = Factory.build(:recipe, :name => nil)
    assert !Recipe.new.valid?
  end
end
