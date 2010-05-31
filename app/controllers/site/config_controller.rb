class Site::ConfigController < ApplicationController
  before_filter {authorize! :manage, :site}
end
