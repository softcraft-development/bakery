ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_girl'
require 'pp'
require 'assertions'
require 'terminator'
# TODO: Reenable for Shoulda on Rails 3
# require "shoulda"

class Factory
  def has_many(collection)
    after_build { |instance|
      yield instance
    }
    after_create { |instance|
      instance.send(collection).each { |i| i.save! }
    }
  end
end

class ActiveSupport::TestCase
  
  
  
  Factory.sequence :prime do |n|
    unless defined? @@prime
      @@prime = Prime.new
      # Burn "2" since it's a commonly used (and possibly significant) number
      @@prime.next
    end
    @@prime.next
  end
  
  Factory.define :recipe do |f|
    f.name "A Factory Recipe"
    f.association :user, :factory => :user
    f.yield {Factory.next(:prime)}
  end

  Factory.define :recipe_with_yield, :parent => :recipe do |f|
    f.yield {Factory.next(:prime)}
    f.yield_size "#{Factory.next(:prime)} kg"
  end

  Factory.define :scalable_recipe, :parent => :recipe_with_yield do |f|    
    f.has_many :ingredients do |recipe|
      Factory.build(:scalable_ingredient, :recipe => recipe)
    end
  end
  
  Factory.define :costable_recipe, :parent => :recipe_with_yield do |f|
    f.has_many :ingredients do |recipe|
      Factory.build(:costable_ingredient, :recipe => recipe)
      Factory.build(:costable_ingredient, :recipe => recipe)
    end
  end  

  Factory.define :food do |f|
    f.name "A Factory Food"
  end
  
  Factory.define :costable_food, :parent => :food do |f|
    f.purchase_amount {"#{Factory.next(:prime)} g"}
    f.purchase_cost {Factory.next(:prime)}    
  end
  
  Factory.define :ingredient do |f|
    f.association :recipe, :factory => :recipe
    f.association :food, :factory => :food
    f.amount {Factory.next(:prime)}
    f.after_build { |i| i.recipe.ingredients << i unless i.recipe.nil? }
  end

  Factory.define :scalable_ingredient, :parent => :ingredient do |f|
    f.association :recipe, :factory => :scalable_recipe
    f.amount "#{Factory.next(:prime)} g"
  end
  
  Factory.define :costable_ingredient, :parent => :scalable_ingredient do |f|
    f.association :food, :factory => :costable_food
  end
  
  Factory.sequence :email do |n|
    "bakery-test-#{n}@softcraft.ca"
  end
  
  Factory.define :user, :class => User do |f|
    f.email { Factory.next(:email) }
    f.password "password"
  end
  
  Factory.define :admin, :parent => :user do |f|
    f.roles [:admin]
  end
end

class ActionController::TestCase
    include Devise::TestHelpers
end

class Ingredient
  def get_update_parameters(new_amount)
    params = { 
      "ingredients_attributes" => {
          "0" => {
            "id" => self.id.to_s,
            "amount" => new_amount.to_s
          }
        }
    }
  end
end