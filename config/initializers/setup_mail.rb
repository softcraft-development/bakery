smtp = APP_CONFIG[:smtp]

ActionMailer::Base.smtp_settings = {
  :address              => smtp[:server],
  :port                 => smtp[:port] || 25,
  :domain               => smtp[:domain],
  :user_name            => smtp[:user],
  :password             => smtp[:password],
  :authentication       => smtp[:authentication_type],
  :enable_starttls_auto => smtp[:use_tls]
}