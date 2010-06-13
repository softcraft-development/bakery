class Recipe < ActiveRecord::Base
  # FIXME: attr_accessible conflicts with nested model attributes
  # attr_accessible :name
  has_many :ingredients, :dependent => :destroy
  belongs_to :user
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
        Recipe.total_yield(self.yield, self.yield_size)
      rescue ArgumentError
        self.yield    
      end
    else
      self.yield
    end
  end
  
  def self.total_yield(yield_, yield_size)
    return yield_size.unit * yield_
  end
  
  def scale(new_yield = nil, new_yield_size = nil)
    new_yield ||= self.yield
    new_yield_size ||= self.yield_size
    
    scaled = Recipe.new
    scaled.id = self.id
    scaled.name = self.name
    scaled.yield_size = new_yield_size
    scaled.slug = self.slug
    
    if new_yield_size.nil?
      scaling_factor = Float(new_yield) / self.yield
    else
      scaling_factor = Recipe.total_yield(new_yield, new_yield_size) / self.total_yield
    end
    
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
