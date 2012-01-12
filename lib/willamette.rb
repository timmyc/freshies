require 'nokogiri'
require 'open-uri'

class Willamette
  CONDITIONS_PAGE = 'http://willamettepass.com/mountain/snowreport.php'
  attr_accessor :doc
  attr_accessor :readings

  def initialize
    self.doc = Nokogiri::HTML(open(CONDITIONS_PAGE))
  end

  def get_data
    updated = self.doc.at_xpath('//p[@class="snowreportupdated"]').text
    table_data = {}
    report_table_cells = self.doc.xpath('//table[@class="snowreportmain"]//tr//td[not(@colspan)]')
    report_table_cells.each_with_index do |td,i|
      if i.even?
        key = slug_me(strip_junk(td.text()))
      else
        key = slug_me(strip_junk(report_table_cells[i-1].text()))
      end
      table_data[key] = strip_junk(td.text())
    end
    # table_data
    # {:status=>"closed", :total_annual_snowfall=>"51\"", :temperature=>"° f", :road_conditions=>"spots of ice", :snow_level_at_lodge=>"14\"", :"12_hour_snowfall"=>"\"", :wind_speed=>"0 - 5 mph", :snow_level_at_midway=>"22\"", :"24_hour_snowfall"=>"\"", :slope_conditions=>"early season", :snow_level_at_peak_2=>"28\"", :weather=>"", :notes=>"", :wind_direction=>"northwest", :requirements=>"carry chains or traction tires", :half_pipe=>"closed"
    self.readings = {
      :report_time => Time.zone.parse(clean_date(updated)),
      :snowfall_twelve => table_data[:"12_hour_snowfall"].to_i,
      :snowfall_twentyfour => table_data[:"24_hour_snowfall"].to_i,
      :base_temp => table_data[:temperature].to_i,
      :base_mid => table_data[:snow_level_at_midway].to_i,
      :base_depth => table_data[:snow_level_at_lodge].to_i
    }
  end

  def strip_junk(str)
    str.gsub(/\t|\r|\n/,'').downcase
  end

  def clean_date(report)
    report.split(':').drop(1).join(':')
  end

  def slug_me(str)
    str = str.downcase.strip
    str = str.gsub(/\.|\(|\)/,'')
    str = str.gsub(' ','_')
    return str.to_sym
  end
end
