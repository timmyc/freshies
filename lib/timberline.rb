require 'nokogiri'
require 'open-uri'

class Timberline
  CONDITIONS_PAGE = 'http://www.timberlinelodge.com/conditions/'
  attr_accessor :doc
  attr_accessor :readings

  def initialize
    self.doc = Nokogiri::HTML(open(CONDITIONS_PAGE))
  end

  def get_data
    stats = doc.xpath('//div[@class="conditions"]//span[@class="stat"]')
    date = doc.xpath('//span[@id="weatherWidgetDate"]').text
    time = doc.xpath('//span[@id="weatherWidgetUpdated"]').text.gsub('Updated ','')
    self.readings = {
      :report_time => Time.zone.parse("#{date} #{time}"),
      :snowfall_twelve => stats.last.text.to_i,
      :snowfall_twentyfour => stats.last.text.to_i,
      :snowfall_seventytwo => self.doc.xpath('//span[@id="snowfall72"]').text.to_i,
      :base_temp => stats.first.text.to_i,
      :base_depth => self.doc.xpath('//span[@id="baseDepth"]').text.to_i
    }
  end

end
