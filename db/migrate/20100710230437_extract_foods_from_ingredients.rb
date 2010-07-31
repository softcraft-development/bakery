class ExtractFoodsFromIngredients < ActiveRecord::Migration
  def self.up
    Ingredient.all.each { |ingredient|
      food = Food.new(
        :name => ingredient.name || "Food #{ingredient.sort_order} for Ingredient #{ingredient.id}",
        :purchase_amount => ingredient.purchase_amount,
        :purchase_cost => ingredient.purchase_cost,
        :user => ingredient.recipe.user
      )
      food.save!
      ingredient.food = food
      ingredient.save!
    }
  end

  def self.down
    Ingredient.all.each { |ingredient|
      food = ingredient.food
      unless food.nil?
        ingredient.name = food.name
        ingredient.purchase_amount = food.purchase_amount
        ingredient.purchase_cost = food.purchase_cost
        ingredient.food = nil
        ingredient.save!
      end
    }
  end
end
