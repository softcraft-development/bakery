class Ingredient < ActiveRecord::Base
  attr_accessible :name, :sort_order, :amount
  belongs_to :recipe
end
