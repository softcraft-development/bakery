class UpdateExistingRecipeYields < ActiveRecord::Migration
  def self.up
    Recipe.all.each { |recipe|
      recipe.yield = 0
      recipe.save
    }
  end
  def self.down
    Recipe.all.each { |recipe|
      recipe.yield = nil
      recipe.save
    }
  end
end
