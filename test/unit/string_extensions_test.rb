require 'test_helper'
require 'string_extensions'

class TestStringExtensions < ActiveSupport::TestCase
  def test_to_nil_blank
    assert_equal nil, "".to_nil
  end
  
  def test_to_nil_non_blank
    assert_equal "a", "a".to_nil
  end
  
  def test_to_nil_nil
    assert_equal nil, nil.to_nil
  end
end