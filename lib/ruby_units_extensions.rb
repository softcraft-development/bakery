class String
  def try_unit
    begin
      self.unit
    rescue
      self
    end
  end
end