class Site::ConfigController < ApplicationController
  before_filter :authenticate_user!
end
