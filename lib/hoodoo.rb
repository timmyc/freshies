require 'nokogiri'
require 'open-uri'

class Hoodoo
  CONDITIONS_PAGE = 'http://www.hoodoo.com/daily-conditions/'
  attr_accessor :doc
  attr_accessor :readings

  def initialize
    self.doc = Nokogiri::HTML(open(CONDITIONS_PAGE))
  end

  def get_data
    updated = self.doc.at_xpath('//li[@class="sidebox "]//div[@class="textwidget"]//p//b//font').text
    table_data = {}
    report_table_cells = self.doc.xpath('//li[@class="sidebox "]//div[@class="textwidget"]//table//tr//td')
    report_table_cells.each_with_index do |td,i|
      if i.even?
        key = slug_me(strip_junk(td.text()))
      else
        key = slug_me(strip_junk(report_table_cells[i-1].text()))
      end
      table_data[key] = strip_junk(td.text())
    end
    #{:lifts_open=>" ed, manzanita, easy rider", :runs_open=>"75%", :new_snow=>"1\"", :autobahn_tubing=>"closed m - th", :snow_depth=>"20.8\"", :snow_bunny_sled_hill=>"closed", :weather=>"snowing", :temp_lodge=>"32", :temp_peak=>"26"}
    self.readings = {
      :report_time => Time.zone.parse(updated),
      :snowfall_twelve => table_data[:new_snow].to_i,
      :base_temp => table_data[:temp_lodge].to_i,
      :summit_temp => table_data[:temp_peak].to_i,
      :base_depth => table_data[:snow_depth].to_i
    }
  end

  def strip_junk(str)
    str.gsub(/\t|\r|\n|\302\260/,'').downcase
  end

  def slug_me(str)
    str = str.downcase.strip
    str = str.gsub(/\.|\(|\)/,'')
    str = str.gsub(' ','_')
    return str.to_sym
  end
end
