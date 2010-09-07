# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Bakery::Application.initialize!
require 'ruby_units_extensions'
require "math_enhancements"
require "hash_extensions"
require "string_extensions"
require 'pp'

Bakery::Application.configure do  
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true  
end
