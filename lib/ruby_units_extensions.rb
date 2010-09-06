class String
  def try_unit
    if blank?
      nil
    else
      begin
        self.unit
      rescue
        self
      end
    end
  end
end

class Unit
  def try_unit
    return self
  end  
end  

class NilClass
  def try_unit
    return nil
  end
end