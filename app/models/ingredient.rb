require 'unit_validator'

class Ingredient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :food
  accepts_nested_attributes_for :food
  attr_accessible :amount, :sort_order, :food_attributes
  # TODO: Re-enable something like this that works
  # validates :recipe, :presence => true
  # validates :food, :presence => true
  validates :amount, :presence => true, :unit => true
  validates :sort_order, :presence => true, :numericality => true
  default_scope :order => "sort_order"
  
  def scale(scaling_factor)
    scaled = self.clone
    scaled.recipe = nil;
    scaled.id = self.id
    scaled.amount = self.amount.unit * scaling_factor
    scaled.freeze
    return scaled
  end
  
  def cost
    return food.cost(self.amount)
  end
  
  def to_ingredient_selector
    selector = IngredientSelector.new
    selector.ingredient = self
    selector.recipe = self.recipe
    selector.food = self.food
    selector.user = (self.recipe.user if self.recipe) or (self.food.user if self.food)
    selector.food_name = self.food.name if self.food
    selector.amount = self.amount
    return selector
  end
end

