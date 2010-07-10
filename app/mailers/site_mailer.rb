class SiteMailer < ActionMailer::Base
  def test_email
    options = {
      :subject => APP_CONFIG[:email_test_subject] + ": " + Time.new.to_s,
      :from => APP_CONFIG[:email_test_from],
      :to => APP_CONFIG[:email_test_to],
    }    
    mail(options)
  end
end
