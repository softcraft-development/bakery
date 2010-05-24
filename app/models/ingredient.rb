class Ingredient < ActiveRecord::Base
  # FIXME: attr_accessible conflicts with nested model attributes
  # attr_accessible :name, :sort_order, :amount
  belongs_to :recipe  
  validates :recipe, :presence => true
  validates :name, :presence => true
  validates :amount, :presence => true, :unit => true
  validates :sort_order, :presence => true, :numericality => true
  default_scope :order => "sort_order"
end

