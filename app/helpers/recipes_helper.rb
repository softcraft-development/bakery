module RecipesHelper
  def current_user_foods_autocomplete
    current_user.foods.map {|food| food_autocomplete_properties(food) }
  end
  
  def food_autocomplete_properties(food)
    properties = food.autocomplete_properties
    properties[:purchase_amount] = na(properties[:purchase_amount])
    properties[:purchase_cost] = dollars(properties[:purchase_cost])
    properties
  end
end
