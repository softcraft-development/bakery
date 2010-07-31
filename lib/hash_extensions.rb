# http://pragmatig.com/2009/04/14/recursive-symbolize_keys/
class Hash
  # Pass either a default value or a block to return it (a la Hash#fetch()).
  # If both are passed, the block will take precedence over the default value
  # http://gist.github.com/437101
  def evoke(key, default = nil)
    if include?(key)
      self[key]
    else
      self[key] = block_given? ? yield : default
    end
  end
end
  