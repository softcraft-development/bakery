`heroku config:clear`
pairs = ""
APP_CONFIG_SETTINGS.each { |key,value|
  pairs += " #{key.to_s}=\"#{value.to_s}\""
}
`heroku config:add #{pairs}`