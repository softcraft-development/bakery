require 'test_helper'

class TestAssertions < ActiveSupport::TestCase
  def test_assert_raise_kind_of_raised
    happened = assert_raise_kind_of TestingException do
      raise SubTestingException
    end    
    assert happened
  end
  
  def test_assert_raise_kind_of_did_not_raise
    happened = assert_raise_kind_of TestingException do
      # la la la la
    end    
    assert !happened
  end
  
  def test_assert_completes_in_success
    ran = false
    assert_completes_in 10 do
      ran = true
    end
    assert ran
  end

  def test_assert_completes_in_failure
    ran = false
    assert_completes_in 1 do
      sleep 2
      ran = true
    end
    assert !ran
  end
end

class TestingException < Exception
end

class SubTestingException < TestingException
end