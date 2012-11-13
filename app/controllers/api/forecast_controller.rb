class Api::ForecastController < ApplicationController
  before_filter :set_area

  def create
    if @area
      @forecast = @area.create_forecast
      render :json => @forecast
    else
      render :text => "unauthorized", :status => :unauthorized
    end
  end

  private

  def set_area
    authenticate_or_request_with_http_basic do |user, password|
      @area = Area.find_by_key_and_secret(user,password)
    end
  end

end

