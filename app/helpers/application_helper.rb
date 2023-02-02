module ApplicationHelper
  include BetterHtml::Helpers

  def site_name
    site_config.name
  end
end
