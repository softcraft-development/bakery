class Site::ErrorsController < ApplicationController
  before_filter :authenticate_user!
  before_filter {authorize! :manage, :site}
  
  def show
    redirect_to(new_site_errors_path)
  end
  
  def new
    respond_to do |format|
      format.html
    end
  end

  def create
    raise "This is an intentionally generated error."
  end
end
