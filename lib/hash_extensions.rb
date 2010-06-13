# http://pragmatig.com/2009/04/14/recursive-symbolize_keys/
class Hash
  def recursive_symbolize_keys!
    symbolize_keys!
    # symbolize each hash in .values
    values.each{|h| h.recursive_symbolize_keys! if h.is_a?(Hash) }
    # symbolize each hash inside an array in .values
    values.select{|v| v.is_a?(Array) }.flatten.each{|h| h.recursive_symbolize_keys! if h.is_a?(Hash) }
    self
  end
  
  def evoke(key, default = nil)
    if include?(key)
      self[key]
    else
      self[key] = block_given? ? yield : default
    end
  end
end
