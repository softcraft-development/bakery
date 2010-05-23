source 'http://rubygems.org'

gem 'rails', '3.0.0.beta3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3-ruby', :require => 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri', '1.4.1'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for certain environments:
# gem 'rspec', :group => :test
# group :test do
#   gem 'webrat'
# end

gem "haml"
gem "ruby-units"
gem "friendly_id"

group :test do
  gem "redgreen"
  # TODO: reenable shoulda once it's working with Rails 3
  # gem "shoulda", :git => "http://github.com/thoughtbot/shoulda.git", :branch => "rails3"
  gem "mocha"
  gem "factory_girl", :git => "http://github.com/thoughtbot/factory_girl.git", :branch => "rails3"
end

group :development do
  gem "nifty-generators"
end
