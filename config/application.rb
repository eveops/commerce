require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module EVECommerce
  class Application < Rails::Application
    config.load_defaults 7.1

    uri = URI(Settings.site.url)
    port = uri.port
    host = [80, 443].include?(port) ? uri.host : "#{uri.host}:#{port}"

    # ActiveJob configuration
    config.active_job.queue_adapter = :sidekiq

    # ActionMailer configuration
    config.action_mailer.asset_host = Settings.site.assets_url || Settings.site.url
    config.action_mailer.default_url_options = {host:}
  end
end
