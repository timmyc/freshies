require 'nokogiri'
require 'open-uri'

class Bachelor
  CONDITIONS_PAGE = 'http://www.mtbachelor.com/winter/mountain/snow_report'
  attr_accessor :doc
  attr_accessor :readings

  def initialize
    self.doc = Nokogiri::HTML(open(CONDITIONS_PAGE))
  end

  def get_data
    updated = self.doc.xpath('//div[@class="snowfall-block odd"]//h6').first.text()
    snowfall_twelve = self.doc.xpath('//div[@class="snowfall-block odd"]//strong').first.text()
    snowfall_twentyfour = self.doc.xpath('//div[@class="snowfall-block even"]//strong').first.text()
    values = self.doc.xpath('//div[@id="mountain-conditions"]//div[@class="label_value-block"]//span[@class="value"]').collect{|i| i.text() }
    keys = self.doc.xpath('//div[@id="mountain-conditions"]//div[@class="label_value-block"]//label').collect{|i| i.text() }
    data = {}
    keys.each_with_index{|k,i| data[slug_me(k)] = values[i].to_i }
    self.readings = {
      :report_time => Time.parse(updated),
      :snowfall_twelve => snowfall_twelve.to_i,
      :snowfall_twentyfour => snowfall_twentyfour.to_i,
      :base_temp => data[:west_village_temperature],
      :mid_temp => data[:pine_marten_temperature],
      :summit_temp => data[:summit_temp],
      :base_depth => data[:west_village_depth],
      :mid_depth => data[:mid_mountain_depth]
    }
  end

  def slug_me(str)
    str = str.split('(').first
    str = str.downcase.strip
    str = str.gsub(':','')
    str = str.gsub(' ','_')
    return str.to_sym
  end
end
