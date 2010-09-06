require 'test_helper'

class StringTest < ActiveSupport::TestCase
  def test_try_unit_valid
    assert_equal "1 lbs", "1 pound".try_unit.to_s
  end

  def test_try_unit_invalid
    assert_equal "1 foo", "1 foo".try_unit.to_s
  end

  def test_nil
    assert_equal nil, nil.try_unit
  end
  
  def test_blank
    assert_equal nil, "".try_unit
  end
end