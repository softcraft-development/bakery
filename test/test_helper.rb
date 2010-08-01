ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'pp'
require 'assertions'
require 'shoulda'
require 'shoulda_macros'
require 'test_factories'
# TODO: Reenable once working
# require 'terminator'

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