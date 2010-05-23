ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_girl'
# TODO: Reenable for Shoulda on Rails 3
# require "shoulda"

class ActiveSupport::TestCase
  Factory.define :recipe do |r|
    r.name "A Factory Recipe"
  end

  Factory.define :ingredient do |i|
    i.association :recipe, :factory => :recipe
    i.name "A Factory ingredient"
  end
end
