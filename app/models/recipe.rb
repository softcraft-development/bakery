class Recipe < ActiveRecord::Base
  attr_accessible :name
  has_many :ingredients
  
  validates_presence_of :name
end
