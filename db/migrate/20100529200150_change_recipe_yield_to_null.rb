class ChangeRecipeYieldToNull < ActiveRecord::Migration
  def self.up
    change_column :recipes, :yield, :float, :null => false
  end

  def self.down
    change_column :recipes, :yield, :float
  end
end
