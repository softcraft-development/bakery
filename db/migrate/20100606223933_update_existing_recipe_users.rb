class UpdateExistingRecipeUsers < ActiveRecord::Migration
  def self.up
    Recipe.all.each { |recipe|
      user ||= UpdateExistingRecipeUsers.load_user
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
  
  def self.load_user
    user = User.admins.first
    unless user
      user = User.create(
        :email => "#{Time.now.to_f}.UpdateExistingRecipeUsers.migration@softcraft.ca",
        :password => rand(1000000).to_s + "123456"  )
    end
    return user
  end
end
