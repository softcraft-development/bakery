class IngredientsController < ApplicationController
  def index
    @recipe = Recipe.find(params[:recipe_id])
    if @recipe
      @ingredients = @recipe.ingredients
    else
      @ingredients = Ingredient.all
    end      
  end
  
  def show
    @ingredient = Ingredient.find(params[:id])
  end
  
  def new
    @recipe = Recipe.find(params[:recipe_id])
    @ingredient = Ingredient.new
  end
  
  def create
    @recipe = Recipe.find(params[:recipe_id])
    @ingredient = Ingredient.new(params[:ingredient])
    @ingredient.recipe = @recipe
    if @ingredient.save
      flash[:notice] = "Successfully created ingredient."
      redirect_to @ingredient
    else
      render :action => 'new'
    end
  end
  
  def edit
    @ingredient = Ingredient.find(params[:id])
  end
  
  def update
    @ingredient = Ingredient.find(params[:id])
    if @ingredient.update_attributes(params[:ingredient])
      flash[:notice] = "Successfully updated ingredient."
      redirect_to @ingredient
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @ingredient = Ingredient.find(params[:id])
    @ingredient.destroy
    flash[:notice] = "Successfully destroyed ingredient."
    redirect_to recipe_ingredients_url(@ingredient.recipe)
  end
end
