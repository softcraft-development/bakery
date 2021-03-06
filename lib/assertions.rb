# TODO: Reenable once working
# require "terminator"

module Test::Unit::Assertions
  def assert_raise_kind_of(target_exception, options = {})
    full_message = options[:message] || "A kind of #{target_exception.class} exception expected but none was thrown."
    assert_block(full_message) do
      begin
        yield
      rescue target_exception
        return true
      else
        return false
      end
    end
  end
  
  # def assert_completes_in(timeout, options = {})
  #   full_message = options[:message] || "The operation did not complete in #{timeout} seconds."
  #   assert_block(full_message) do
  #     begin
  #       Terminator.terminate timeout do
  #         yield
  #         return true
  #       end
  #     rescue Terminator::Error
  #       return false
  #     end
  #   end
  # end
  
  def assert_all(collection)
    has_any = false
    collection.each do |x|
      yield x
      has_any ||= true
    end
    assert has_any, "Did not assert on any elements"
  end
  
  def assert_float_equal(expected, actual)
    assert_in_delta(expected.to_f, actual.to_f, 0.00001)
  end
end