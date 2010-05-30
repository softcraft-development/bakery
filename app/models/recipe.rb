class Recipe < ActiveRecord::Base
  # FIXME: attr_accessible conflicts with nested model attributes
  # attr_accessible :name
  has_many :ingredients, :dependent => :destroy
  accepts_nested_attributes_for :ingredients, :reject_if => lambda { |a| a[:name].blank? || a[:amount].blank? }, :allow_destroy => true
  has_friendly_id :name, :use_slug => true
  validates_presence_of :name
  
  def yield_string
    "%.1d" % self.yield
  end
  
  def yield_string=(value)
    self.yield = Float(value)
  end
  
  def total_yield
    if !yield_size.nil?
      begin
        yield_size.unit * self.yield
      rescue ArgumentError
        self.yield    
      end
    else
      self.yield
    end
  end
  
  def scale(new_yield)
    scaled = Recipe.new
    scaled.id = self.id
    scaled.name = self.name
    scaled.yield_size = self.yield_size
    
    scaling_factor = new_yield.to_f / self.yield
    self.ingredients.each { |ingredient|      
      scaled_ingredient = ingredient.scale(scaling_factor)
      scaled_ingredient.recipe = scaled
      scaled.ingredients << scaled_ingredient
    }
    scaled.yield = new_yield
    
    scaled.freeze
    return scaled
  end
end
