class Site::MailsController < ApplicationController
  before_filter :authenticate_user!
  before_filter {authorize! :manage, :site}
  
  def show
    redirect_to(new_site_mail_path)
  end
  
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mail }
    end
  end

  def create
    respond_to do |format|
      begin
        SiteMailer.test_email.deliver 
      rescue Exception => ex
        logger.error(ex)
        flash[:notice] = "Error: " + ex.message
        format.html { render :action => "new" }
      else
        format.html { redirect_to(new_site_mail_path, :notice => 'Mail was successfully created.') }
      end
    end
  end
end
