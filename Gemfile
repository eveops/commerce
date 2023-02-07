source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"

gem "rails", github: "rails/rails", branch: "main"

gem "bcrypt", "~> 3.1"
gem "better_html", "~> 2.0"
gem "bootsnap", "~> 1.16", require: false
gem "config", "~> 4.1"
gem "cssbundling-rails", "~> 1.1"
gem "jbuilder", "~> 2.11"
gem "jsbundling-rails", "~> 1.1"
gem "kredis", "~> 1.3"
gem "pg", "~> 1.4"
gem "pghero", "~> 3.1"
gem "puma", "~> 6.0"
gem "rack-mini-profiler", "~> 3.0"
gem "redis", ">= 4.0.1"
gem "sidekiq", "~> 7.0"
gem "sidekiq-scheduler", "~> 5.0"
gem "sprockets-rails", "~> 3.4"
gem "stimulus-rails", "~> 1.2"
gem "turbo-rails", "~> 1.3"

group :development, :test do
  gem "debug", "~> 1.7"
end

group :development do
  gem "brakeman", "~> 5.4", require: false
  gem "bundle-audit", "~> 0.1.0", require: false
  gem "erb_lint", "~> 0.3.1", require: false
  gem "error_highlight", "~> 0.5"
  gem "fast_ignore", "~> 0.17.4", require: false
  gem "rubocop-minitest", "~> 0.27.0", require: false
  gem "rubocop-performance", "~> 1.15", require: false
  gem "rubocop-rails", "~> 2.17", require: false
  gem "rubocop-rake", "~> 0.6.0", require: false
  gem "standard", "~> 1.23", require: false
  gem "web-console", "~> 4.2"
end

group :test do
  gem "capybara", "~> 3.38"
  gem "selenium-webdriver", "~> 4.8"
  gem "webdrivers", "~> 5.2"
end
