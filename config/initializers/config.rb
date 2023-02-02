Config.setup do |config|
  config.const_name = "Settings"
  config.use_env = true
  config.env_prefix = "EVE_COMMERCE"
  config.env_separator = "__"

  config.schema do
    required(:site).schema do
      optional(:assets_url).filled(format?: URI::DEFAULT_PARSER.make_regexp)
      required(:name).filled(:string)
      required(:url).filled(format?: URI::DEFAULT_PARSER.make_regexp)
    end
  end
end
