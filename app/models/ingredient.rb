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
    self.amount = self.amount.unit * scaling_factor
    return self
  end
  
  def cost
    return food.cost(self.amount)
  end
  
  def self.empty
    i = Ingredient.new
    i.food = Food.new
    return i
  end
end

