class Recipe < ActiveRecord::Base
  # FIXME: attr_accessible conflicts with nested model attributes
  # attr_accessible :name
  has_many :ingredients, :dependent => :destroy
  accepts_nested_attributes_for :ingredients, :reject_if => lambda { |a| a[:name].blank? || a[:amount].blank? }, :allow_destroy => true
  has_friendly_id :name, :use_slug => true
  validates_presence_of :name
end
