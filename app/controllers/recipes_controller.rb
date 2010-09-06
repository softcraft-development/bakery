class RecipesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @recipes = current_user.recipes
  end
  
  def show
    @recipe = Recipe.find(params[:id])
    recipe_yield = params[:yield]
    unless recipe_yield.blank? 
      if params[:yield_size].blank?
        flash[:error] = "How big are your new serving sizes? We need to know before we can show you the recipe."
      elsif
        @recipe = @recipe.scale(recipe_yield, params[:yield_size]) 
        @scaled = true
      end
    end
  end
  
  def new
    @recipe = Recipe.new
    @ingredients = [IngredientSelector.new]
  end
  
  def create
    @recipe = Recipe.new(params[:recipe])
    @recipe.user = current_user
    if @recipe.save
      flash[:notice] = "Successfully created recipe."
      redirect_to @recipe
    else
      render :action => 'new'
    end
  end
  
  def edit
    @recipe = Recipe.find(params[:id])
    @ingredients = @recipe.ingredient_selectors << IngredientSelector.new
  end
  
  def update
    @recipe = Recipe.find(params[:id])
    # @recipe.ingredients.to_s
    if @recipe.update_attributes(params[:recipe])
      @recipe = Recipe.find(@recipe.id)
      flash[:notice] = "Successfully updated recipe."
      redirect_to @recipe
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    flash[:notice] = "Successfully destroyed recipe."
    redirect_to recipes_url
  end
end
