class AddYieldToRecipe < ActiveRecord::Migration
  def self.up
    add_column :recipes, :yield, :float
    add_column :recipes, :yield_size, :string
  end

  def self.down
    remove_column :recipes, :yield_size
    remove_column :recipes, :yield
  end
end
