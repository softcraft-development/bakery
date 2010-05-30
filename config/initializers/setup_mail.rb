settings = APP_CONFIG[:smtp].dup
settings[:authentication] = settings[:authentication].to_sym unless settings[:authentication].nil?

ActionMailer::Base.smtp_settings = settings