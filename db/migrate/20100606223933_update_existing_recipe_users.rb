class UpdateExistingRecipeUsers < ActiveRecord::Migration
  def self.up
    Recipe.all.each { |recipe|
      user ||= User.evoke_admin
      recipe.user = user unless recipe.user
      recipe.save!
    }
  end

  def self.down
    Recipe.all.each { |recipe|
      recipe.user = nil
      recipe.save!
    }
  end
end
