class SitesController < ApplicationController
  before_filter :authenticate_user!
  before_filter {authorize! :manage, :site}
  
  def show
   
    respond_to do |format|
      format.html
    end
  end
end
