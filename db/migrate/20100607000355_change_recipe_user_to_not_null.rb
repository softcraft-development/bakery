class ChangeRecipeUserToNotNull < ActiveRecord::Migration
  def self.up
    change_column :recipes, :user_id, :int, :null => false
  end

  def self.down
    change_column :recipes, :user_id, :int
  end
end
