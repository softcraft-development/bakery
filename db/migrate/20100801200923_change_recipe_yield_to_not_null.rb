class ChangeRecipeYieldToNotNull < ActiveRecord::Migration
  def self.up
    change_column :recipes, :yield, :float, :null => true
  end

  def self.down
    change_column :recipes, :yield, :float, :null => false
  end
end
