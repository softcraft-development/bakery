require 'test_helper'

class StringTest < ActiveSupport::TestCase
  def test_try_unit_valid
    assert "1 lbs", "1 pound".try_unit.to_s
  end

  def test_try_unit_invalid
    assert "1 foo", "1 foo".try_unit.to_s
  end
end