require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  def test_dollars_number
    target = Factory.next(:prime)
    assert_equal number_to_currency(target), dollars(target)
  end

  def test_dollars_nil
    assert_equal "No Dollars", dollars(nil, "No Dollars")
  end
end