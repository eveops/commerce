class ApplicationController < ActionController::Base
  private

  helper_method :site_config
  def site_config
    Settings.site
  end
end
