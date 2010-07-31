require 'test_helper'

class TestRecursiveSymbolizeKeys < ActiveSupport::TestCase
  def test_object
    assert_equal "value", "value".recursive_symbolize_keys
  end
  
  def test_nil
    assert_equal nil, nil.recursive_symbolize_keys
  end
  
  def test_hash
    hash = {"key" => "value"}
    hash = hash.recursive_symbolize_keys
    assert_equal "value", hash[:key]
  end
  
  def test_array_no_hashes
    array = [1,2,3].recursive_symbolize_keys
    assert_equal [1,2,3], array
  end

  def test_array_new_array
    original = [1,2,3]
    symbolized = original.recursive_symbolize_keys
    assert_not_same original, symbolized
  end
  
  def test_array_of_hashes
    array = [
      {"a" => "0a", "b" => "0b"},
      {"a" => "1a", "b" => "1b"},
      ]
    array = array.recursive_symbolize_keys
    assert_equal "0a", array[0][:a]
    assert_equal "0b", array[0][:b]
    assert_equal "1a", array[1][:a]
    assert_equal "1b", array[1][:b]
  end

  def test_hash_of_array_ofhashes
    hash = {
      "a" => 
        [
          {"a" => "a0a", "b" => "a0b"},
          {"a" => "a1a", "b" => "a1b"},
        ],
      "b" => 
        [
          {"a" => "b0a", "b" => "b0b"},
          {"a" => "b1a", "b" => "b1b"},
        ]
      }
    hash = hash.recursive_symbolize_keys
    assert_equal "a0a", hash[:a][0][:a]
    assert_equal "a0b", hash[:a][0][:b]
    assert_equal "a1a", hash[:a][1][:a]
    assert_equal "a1b", hash[:a][1][:b]
    assert_equal "b0a", hash[:b][0][:a]
    assert_equal "b0b", hash[:b][0][:b]
    assert_equal "b1a", hash[:b][1][:a]
    assert_equal "b1b", hash[:b][1][:b]
  end
end