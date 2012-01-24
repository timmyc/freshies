require 'nokogiri'
require 'open-uri'

class Stevenspass
  CONDITIONS_PAGE = 'http://www.stevenspass.com/Stevens/index.aspx'
  attr_accessor :doc
  attr_accessor :readings

  def initialize
    self.doc = Nokogiri::HTML(open(CONDITIONS_PAGE))
  end

  def get_data
    # Updated At
    updated = self.doc.xpath('//div[@id="popupWeatherContent"]//div[@class="weatherData"]').children.last.text

    report_table_cells = self.doc.xpath('//div[@id="popupWeatherContent"]//td[not(@colspan|@rowspan)]')
    conditions = {}
    report_table_cells.each do |cell|
      key = cell.children.first.text
      value = cell.children.last.text
      conditions[key.to_sym] = value
    end
    #{:Overnight=>"0''", :Base=>"90''", :"Last 24"=>"0''", :Temp=>"21Â°"}

    self.readings = {
      :report_time => Time.zone.parse(updated),
      :snowfall_twelve => conditions[:Overnight].to_i,
      :snowfall_twentyfour => conditions[:"Last 24"].to_i,
      :base_temp => conditions[:Temp].to_i,
      :base_depth => conditions[:Base].to_i
    }
  end
end
