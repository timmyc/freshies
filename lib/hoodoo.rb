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
    updated = self.doc.at_xpath('//div[@id="right"]//li[@class="sidebox "]//div[@class="textwidget"]//strong').text
    table_data = {}
    report_table_cells = self.doc.xpath('//li[@class="sidebox "]//div[@class="textwidget"]//table//tr//td')
    report_table_cells = self.doc.xpath('//table[@class="easy-table-creator"]//tr//td')
    report_table_cells.each_with_index do |td,i|
      next unless td.children && td.children.size >= 2
      key = slug_me(strip_junk(td.children.first.text()))
      table_data[key] = strip_junk(td.children[1].text())
    end
    #{:lifts_open=>" ed, manzanita, easy rider", :runs_open=>"75%", :new_snow=>"1\"", :autobahn_tubing=>"closed m - th", :snow_depth=>"20.8\"", :snow_bunny_sled_hill=>"closed", :weather=>"snowing", :temp_lodge=>"32", :temp_peak=>"26"}
    self.readings = {
      :report_time => Time.zone.parse(updated),
      :snowfall_twelve => table_data[:new_snow_24_hrs].to_i,
      :base_temp => table_data[:temp_lodge].to_i,
      :base_depth => table_data[:snow_level].to_i
    }
  end

  def strip_junk(str)
    str.gsub(/\t|\r|\n/,'').downcase
  end

  def slug_me(str)
    str = str.downcase.strip
    str = str.gsub(/\:|\.|\(|\)/,'')
    str = str.gsub(' ','_')
    return str.to_sym
  end
end
