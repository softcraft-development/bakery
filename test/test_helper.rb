ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_girl'
require 'pp'
require 'assertions'
require 'terminator'
require 'mathn'
# TODO: Reenable for Shoulda on Rails 3
# require "shoulda"

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

  Factory.define :scalable_recipe, :parent => :recipe do |f|
    f.yield {Factory.next(:prime)}
    f.yield_size "#{Factory.next(:prime)} kg"
    f.after_build { |recipe|
      recipe.ingredients << Factory.build(:scalable_ingredient, :recipe => recipe)
    }
    f.after_create { |recipe|
      recipe.ingredients << Factory.create(:scalable_ingredient, :recipe => recipe)
    }
  end
  
  Factory.define :ingredient do |f|
    f.association :recipe, :factory => :recipe
    f.name "A Factory ingredient"
    f.amount {Factory.next(:prime)}
  end

  Factory.define :scalable_ingredient, :parent => :ingredient do |f|
    f.association :recipe, :factory => :scalable_recipe
    f.amount "#{Factory.next(:prime)} g"
  end
  
  Factory.define :costable_ingredient, :parent => :scalable_ingredient do |f|
    f.purchase_amount {Factory.next(:prime)}
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
