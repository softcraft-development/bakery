require "terminator"

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
  
  def assert_completes_in(timeout, options = {})
    full_message = options[:message] || "The operation did not complete in #{timeout} seconds."
    assert_block(full_message) do
      begin
        Terminator.terminate timeout do
          yield
          return true
        end
      rescue Terminator::Error
        return false
      end
    end
  end
end