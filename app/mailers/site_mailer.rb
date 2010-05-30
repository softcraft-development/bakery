class SiteMailer < ActionMailer::Base
  def test_email
    options = APP_CONFIG[:site][:email][:test].dup
    options[:subject] = options[:subject] + ": " + Time.new.to_s
    mail(options)
  end
end
