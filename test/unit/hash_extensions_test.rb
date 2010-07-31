require 'test_helper'
require 'hash_extensions'

class TestHashExtensions < ActiveSupport::TestCase
  def test_evoke_found_block
    hash = {:test => "test"}
    assert_equal "test", hash.evoke(:test) {"not test"}
  end
  
  def test_evoke_found_default
    hash = {:test => "test"}
    assert_equal "test", hash.evoke(:test, "not test")
  end

  def test_evoke_returns_default
    hash = {}
    assert_equal "not test", hash.evoke(:test, "not test")
  end
  
  def test_evoke_returns_block
    hash = {}
    assert_equal "test", hash.evoke(:test) {"test"}
  end

  def test_evoke_found_default_does_not_add
    hash = {:test => "test"}
    hash.evoke(:test, "not test")
    assert_equal "test", hash[:test]
  end
  
  def test_evoke_found_block_does_not_add
    hash = {:test => "test"}
    hash.evoke(:test) {"not test"}
    assert_equal "test", hash[:test]
  end

  def test_evoke_default_adds
    hash = {}
    hash.evoke(:test, "test")
    assert_equal "test", hash[:test]
  end

  def test_evoke_block_adds
    hash = {}
    hash.evoke(:test) { "test" }
    assert_equal "test", hash[:test]
  end
end