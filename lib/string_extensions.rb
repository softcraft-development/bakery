class String
  def to_nil
    blank? ? nil : self
  end
end

class NilClass
  def to_nil
    return self
  end
end