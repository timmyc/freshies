class SnowReportsController < ApplicationController
  before_filter :set_resort

  def create
    worker = Module.const_get(@area.klass).new
    data = worker.get_data
    report = @area.snow_reports.first(:conditions => { :report_time => data[:report_time]})
    if !report
      report = @area.snow_reports.create(data)
    else
      report.update_attributes(data)
    end
    render :json => report
  end

  def index
  end

  def show
  end

  private

  def set_resort
    @area = Area.find_by_key_and_secret(params[:key],params[:secret])
    render :text => "unauthorized", :status => :unauthorized unless @area
  end
end
