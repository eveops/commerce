class ApplicationController < ActionController::Base
  private

  helper_method :app_config
  def app_config
    Rails.application.config
  end

  helper_method :site_config
  def site_config
    app_config.site
  end
end
