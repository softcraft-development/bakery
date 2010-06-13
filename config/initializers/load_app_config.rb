require "hash_extensions"

app_config_file_name = "#{Rails.root}/config/app_config.yml"
if File.exists? app_config_file_name
  raw_config = File.read(app_config_file_name)
  APP_CONFIG = ENV.to_hash.symbolize_keys # Heroku configuration comes from the environment
else
  APP_CONFIG = {}
end
all_config = YAML.load(raw_config).recursive_symbolize_keys!
APP_CONFIG.merge! all_config[:common]
APP_CONFIG.merge! all_config[Rails.env.to_sym]
