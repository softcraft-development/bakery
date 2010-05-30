class RecipeScale
  attr_reader :yield, :yield_size
  def initialize(yield_, yield_size)
    @yield = yield_
    @yield_size = yield_size
  end
end