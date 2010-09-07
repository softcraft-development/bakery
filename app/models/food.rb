class Food < ActiveRecord::Base
  validates :name, :presence => true
  belongs_to :user
  has_many :ingredients, :dependent => :destroy
  
  scope :for_user, lambda {
    where("foods.user")
  }

  def cost(amount)
    return nil unless purchase_amount && purchase_cost
    purch = purchase_amount.unit
    return nil unless amount.unit.compatible_with? purch
    return 0 if purch.zero?
    return (amount.unit.to(purch) / purch) * purchase_cost
  end
  
  def autocomplete_properties
    { 
      :id => self.id, 
      :label => self.name, 
      :purchase_amount => self.purchase_amount.to_nil,
      :purchase_cost => self.purchase_cost
    }
  end
end
