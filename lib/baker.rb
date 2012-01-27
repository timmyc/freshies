require 'nokogiri'
require 'open-uri'

class Baker
  CONDITIONS_PAGE = 'http://www.mtbaker.us/snow_report/index.php'
  attr_accessor :doc
  attr_accessor :readings

  def initialize
    self.doc = Nokogiri::HTML(open(CONDITIONS_PAGE))
  end

  def get_data
    # Updated At
    #updated = self.doc.xpath('//div[@id="popupWeatherContent"]//div[@class="weatherData"]').children.last.text

    conditions = {}
    data = self.doc.xpath('//comment()').last.text.split('--').last
    data.split('|~').each do |point|
      kvp = point.split('|')
      conditions[kvp.first.strip.to_sym] = kvp.last
    end
    # {:"24hourtotal"=>"1 in.", :lastupdated=>"2012-01-27 04:43:27", :newstormtotal=>"1 in.", :surface_depth_base=>"142 in.", :surface_depth_summit=>"181 in.", :current_temp_base=>"22 F", :current_temp_summit=>"22 F"}

    self.readings = {
      :report_time => Time.zone.parse(conditions[:lastupdated]),
      :snowfall_twelve => conditions[:newstormtotal].to_i,
      :base_temp => conditions[:current_temp_base].to_i,
      :summit_temp => conditions[:current_temp_summit].to_i,
      :base_depth => conditions[:surface_depth_base].to_i
    }
  end
end
