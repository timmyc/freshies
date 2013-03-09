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
    date = self.doc.xpath('//table[@class="full layout"]//tr//td[1]//h3').text()
    time = self.doc.xpath('//table[@class="full layout"]//tr//td[2]//h3//strong').text()
    updated = "#{date} #{time}"
    snowfall_twelve = self.doc.xpath('//table[@class="snow-conditions-table layout full"][2]//tr[1]//td[1]//p//span').text()
    snowfall_twentyfour = self.doc.xpath('//table[@class="snow-conditions-table layout full"][2]//tr[1]//td[2]//p//span').text()
    base_depth = self.doc.xpath('//table[@class="snow-conditions-table layout full"][2]//tr[1]//td[8]//p//span').text().to_i
    mid_depth = self.doc.xpath('//table[@class="snow-conditions-table layout full"][1]//tr[1]//td[8]//p//span').text().to_i
    temps = doc.xpath('//table[@id="conditions-weather-table"]//tr[2]//td[1]//p//strong')
    summit_temp = temps[0].text().to_i
    mid_temp = temps[1].text().to_i
    base_temp = temps[2].text().to_i
    
    self.readings = {
      :report_time => Time.zone.parse(updated),
      :snowfall_twelve => snowfall_twelve.to_i,
      :snowfall_twentyfour => snowfall_twentyfour.to_i,
      :base_temp => base_temp,
      :mid_temp => mid_temp,
      :summit_temp => summit_temp,
      :base_depth => base_depth,
      :mid_depth => mid_depth
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
