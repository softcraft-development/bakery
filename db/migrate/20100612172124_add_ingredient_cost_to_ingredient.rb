class AddIngredientCostToIngredient < ActiveRecord::Migration
  def self.up
    add_column :ingredients, :purchase_amount, :string
    add_column :ingredients, :purchase_cost, :decimal
  end

  def self.down
    remove_column :ingredients, :purchase_cost
    remove_column :ingredients, :purchase_amount
  end
end
