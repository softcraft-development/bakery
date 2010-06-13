require 'test_helper'

class TestMathExtensions < ActiveSupport::TestCase
  def test_rational_and_bigdecimal_division
    r = 1 / 4
    d = BigDecimal.new("2")
    assert_equal (r / d), 0.125
  end

  def test_rational_and_bigdecimal_multiplication
    r = 1 / 4
    d = BigDecimal.new("2")
    assert_equal (r * d), 0.5
  end
end