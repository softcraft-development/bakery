class Recipe < ActiveRecord::Base
  attr_accessible :name
  has_many :ingredients, :dependent => :destroy
  has_friendly_id :name, :use_slug => true
  
  validates_presence_of :name
end
