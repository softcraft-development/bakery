settings = APP_CONFIG[:smtp].dup
settings[:authentication] = settings[:authentication].to_sym unless settings[:authentication].nil?

ActionMailer::Base.smtp_settings = settings

ActionMailer::Base.default_url_options[:host] = APP_CONFIG[:domain]
Mail.register_interceptor(DevelopmentMailInterceptor) unless Rails.env.production?
