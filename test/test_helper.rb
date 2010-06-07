ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_girl'
require 'pp'
require 'assertions'
require 'terminator'
# TODO: Reenable for Shoulda on Rails 3
# require "shoulda"

class ActiveSupport::TestCase
  Factory.define :recipe do |f|
    f.name "A Factory Recipe"
    f.association :user, :factory => :user
    f.yield 1
  end

  Factory.define :scalable_recipe, :parent => :recipe do |f|
    f.yield 3
    f.yield_size "5 kg"
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
    f.amount "1 cup"
  end

  Factory.define :scalable_ingredient, :parent => :ingredient do |f|
    f.association :recipe, :factory => :scalable_recipe
    f.amount "7 g"
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
