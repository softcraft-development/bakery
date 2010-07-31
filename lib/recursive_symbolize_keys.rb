require "pp"
# http://pragmatig.com/2009/04/14/recursive-symbolize_keys/
class Object
  def recursive_symbolize_keys
    self
  end
end

class Hash
  def recursive_symbolize_keys
    symbolized = {}
    each{ |key,value| 
      symbolized[key.to_sym] = value.recursive_symbolize_keys
    }
    symbolized
  end
end

class Array
  def recursive_symbolize_keys
    map {|element| 
      element = element.recursive_symbolize_keys 
    }
  end
end