class Api::AreaController < ApplicationController
  before_filter :set_area

  def last_report
    render :json => @area.last_snow_report.first
  end

  private

  def set_area
    @area = Area.find_by_key(params[:id])
  end

end

