settings = { 
  :address => APP_CONFIG[:email_smtp_host],
  :port => APP_CONFIG[:email_smtp_port],
  :domain => APP_CONFIG[:email_smtp_domain],
  :user_name => APP_CONFIG[:email_smtp_user_name],
  :password => APP_CONFIG[:email_smtp_password],
  :enable_starttls_auto => APP_CONFIG[:email_smtp_enable_starttls_auto]
  }
settings[:authentication] = APP_CONFIG[:email_smtp_authentication].to_sym unless settings[:email_smtp_authentication].nil?

ActionMailer::Base.smtp_settings = settings

ActionMailer::Base.default_url_options[:host] = APP_CONFIG[:email_smtp_host]
Mail.register_interceptor(DevelopmentMailInterceptor) unless Rails.env.production?
