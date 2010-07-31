class AddFoodToIngredient < ActiveRecord::Migration
  def self.up
    add_column :ingredients, :food_id, :int
  end

  def self.down
    remove_column :ingredients, :food_id
  end
end
