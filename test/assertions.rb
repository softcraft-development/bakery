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
end