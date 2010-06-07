class UpdateExistingRecipeUsers < ActiveRecord::Migration
  def self.up
    Recipe.all.each { |recipe|
      user ||= load_user
      recipe.user = user unless recipe.user
    }
  end

  def self.down
    Recipe.all.each { |recipe|
      recipe.user = nil
    }
  end
  
  def load_user
    user = User.admins.first
  end
end
