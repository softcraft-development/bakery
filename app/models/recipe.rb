class Recipe < ActiveRecord::Base
  has_many :ingredients, :dependent => :destroy
  accepts_nested_attributes_for :ingredients, :reject_if => lambda { |a| a[:amount].blank? }, :allow_destroy => true
  attr_accessible :name, :yield, :yield_size, :ingredients_attributes, :user
  belongs_to :user
  has_friendly_id :name, :use_slug => true
  validates_presence_of :name
  before_validation :push_user_to_ingredients
  
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
  
  def cost
    return ingredients.inject(0) do |total, ingredient| 
      return nil if total == nil 
      return nil if ingredient.cost == nil 
      total + ingredient.cost
    end
  end
  
  def unit_cost
    total_cost = cost
    return nil if total_cost == nil
    return nil unless self.yield
    return total_cost / self.yield
  end
  
  def push_user_to_ingredients()
    ingredients.each do |ingredient|
       ingredient.food.user ||= user if ingredient.food
    end
  end
end
