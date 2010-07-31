class RemoveFoodFieldsFromIngredient < ActiveRecord::Migration
  def self.up
    remove_column :ingredients, :name
    remove_column :ingredients, :purchase_amount, :name
    remove_column :ingredients, :purchase_cost, :name
  end

  def self.down
    add_column :ingredients, :name, :string
    add_column :ingredients, :purchase_amount, :string
    add_column :ingredients, :purchase_cost, :decimal
  end
end
