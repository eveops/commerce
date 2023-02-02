Settings.rack_mini_profiler.tap do |config|
  Rack::MiniProfiler.config.skip_paths = [
    "/pghero",
    "/sidekiq"
  ]

  Rack::MiniProfiler.config.enable_hotwire_turbo_drive_support = true
  Rack::MiniProfiler.config.assets_url = ->(name, version, env) {
    ActionController::Base.helpers.asset_path(name)
  }

  # Configurable settings
  Rack::MiniProfiler.config.position = config.position
  Rack::MiniProfiler.config.start_hidden = config.start_hidden
end