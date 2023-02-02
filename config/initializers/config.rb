Config.setup do |config|
  config.const_name = 'Settings'
  config.use_env = true
  config.env_prefix = 'EVE_COMMERCE'
  config.env_separator = '__'

  # Validate presence and type of specific config values. Check https://github.com/dry-rb/dry-validation for details.
  #
  # config.schema do
  #   required(:name).filled
  #   required(:age).maybe(:int?)
  #   required(:email).filled(format?: EMAIL_REGEX)
  # end
end
