class IngredientSelector
  extend ActiveModel::Naming
  
  attr_accessor :amount, :food_name, :recipe, :food, :ingredient, :user
  
  def food_for_name
    self.user.foods.with_name(self.food_name).first if self.user.respond_to?(:foods)
  end
  
  def to_ingredient
    self.ingredient ||= Ingredient.new
    self.ingredient.recipe = self.recipe || self.ingredient.recipe
    self.ingredient.food = self.food || food_for_name || self.ingredient.food
    self.ingredient.amount = self.amount || self.ingredient.amount
    return self.ingredient
  end
end