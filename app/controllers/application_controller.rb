class ApplicationController < ActionController::Base
  before_filter :set_defaults
  protect_from_forgery

  def after_sign_in_path_for(resource)
    confirm_url
  end
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private

  def set_defaults
    @snow_report = SnowReport.last
  end
  
end
