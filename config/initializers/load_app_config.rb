require "hash_extensions"

raw_config = File.read("#{Rails.root}/config/app_config.yml")
APP_CONFIG = ENV.to_hash.symbolize_keys # Heroku configuration comes from the environment
all_config = YAML.load(raw_config).recursive_symbolize_keys!
APP_CONFIG.merge! all_config[:common]
APP_CONFIG.merge! all_config[Rails.env.to_sym]
