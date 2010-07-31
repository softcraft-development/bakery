require "recursive_symbolize_keys"

APP_CONFIG = ENV.to_hash.symbolize_keys # Heroku configuration comes from the environment

app_config_file_name = "#{Rails.root}/config/app_config.yml"
APP_CONFIG_SETTINGS = {}
if File.exists? app_config_file_name
  raw_config = File.read(app_config_file_name)
  all_config = YAML.load(raw_config).recursive_symbolize_keys
  APP_CONFIG_SETTINGS.merge! all_config[:common]
  APP_CONFIG_SETTINGS.merge! all_config[Rails.env.to_sym]
end

APP_CONFIG.merge! APP_CONFIG_SETTINGS