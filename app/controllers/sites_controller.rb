class SitesController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    respond_to do |format|
      format.html
    end
  end
end
