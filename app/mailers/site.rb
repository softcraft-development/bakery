class Site < ActionMailer::Base
  def test_email
    mail(APP_CONFIG[:site][:email][:test])
  end
end
