class Ingredient < ActiveRecord::Base
  attr_accessible :name, :sort_order, :amount
end
