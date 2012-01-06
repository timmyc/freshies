require 'nokogiri'
require 'open-uri'

class Mthoodmeadows 
  CONDITIONS_PAGE = 'http://www.skihood.com/The-Mountain/Conditions'
  attr_accessor :doc
  attr_accessor :readings

  def initialize
    self.doc = Nokogiri::HTML(open(CONDITIONS_PAGE))
  end

  def get_data
    # Updated At
    updated = self.doc.at_xpath('//span[@class="date-header"]').text

    # Base Readings
    # ["\r\n\t\t\t\t", "Temperature:", " 20° F (-6° C)", "", "Base Snow Depth:", " 48", ""] 
    base_temp = self.doc.xpath('//div[@id="base"]//p').last.children[2].text.to_i
    base_depth = self.doc.xpath('//div[@id="base"]//p').last.children[5].text.to_i

    # Top Readings
    #  ["\r\n\t\t\t\t", "Temperature:", " 17° F (-8° C)", "", "Wind:", " North at 0 mph (0 km/h)", ""] 
    top_temp = self.doc.xpath('//div[@id="top"]//p').last.children[2].text.to_i

    # Conditions ul
    # {:new_snow_past_24_hours=>" 2", :new_snow_past_12_hours=>" 2", :mid_snow_depth=>" 48", :surface_conditions=>"...", :general_comments=>"...", :road_conditions=>"..."}
    conditions = {}
    self.doc.xpath('//ul[@class="clean"]//li').each do |li|
      conditions[slug_me(li.children.first.text)] = li.children.last.text
    end

    self.readings = {
      :report_time => Time.zone.parse(updated),
      :snowfall_twelve => conditions[:new_snow_past_12_hours].to_i,
      :snowfall_twentyfour => conditions[:new_snow_past_24_hours].to_i,
      :base_temp => base_temp.to_i,
      :mid_temp => top_temp.to_i,
      :base_depth => base_depth.to_i,
      :mid_depth => conditions[:mid_snow_depth].to_i
    }
  end

  def slug_me(str)
    str = str.downcase.strip
    str = str.gsub(/\:|\.|\(|\)/,'')
    str = str.gsub(' ','_')
    return str.to_sym
  end
end
