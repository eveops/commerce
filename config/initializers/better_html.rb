BetterHtml.config = BetterHtml::Config.new(YAML.load_file(Rails.root.join(".better-html.yml")))

BetterHtml.configure do |config|
  config.template_exclusion_filter = proc { |filename| !filename.start_with?(Rails.root.to_s) }
end
