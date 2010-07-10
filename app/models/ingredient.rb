class Ingredient < ActiveRecord::Base
  belongs_to :recipe  
  # TODO: Re-enable something like this that works
  # validates :recipe, :presence => true
  validates :name, :presence => true
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
    return nil unless purchase_amount && purchase_cost
    return nil unless amount.unit.compatible_with? purchase_amount.unit
    return 0 if purchase_amount.unit.zero?
    purch = purchase_amount.unit
    return (amount.unit.to(purch) / purch) * purchase_cost
  end
end

