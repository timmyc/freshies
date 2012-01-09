require 'nokogiri'
require 'open-uri'

class Skibowl
  CONDITIONS_PAGE = 'http://www.skibowl.com/conditions/'
  attr_accessor :doc
  attr_accessor :readings

  def initialize
    self.doc = Nokogiri::HTML(open(CONDITIONS_PAGE))
  end

  def get_data
    table_data = {}
    report_table_cells = self.doc.xpath('//div[@class="post"]//table//table//tbody//tr/td[not(@colspan)]')
    report_table_cells.each_with_index do |td,i|
      if i.even?
        key = slug_me(strip_junk(td.text()))
      else
        key = slug_me(strip_junk(report_table_cells[i-1].text()))
      end
      table_data[key] = strip_junk(td.text())
    end
    self.readings = {
      :report_time => Time.zone.parse(clean_date(table_data)),
      :snowfall_twelve => table_data[:new_snow_past_24_hrs].to_i,
      :base_temp => table_data[:temp].to_i,
      :base_depth => table_data[:snow_depth].to_i
    }
  end

  def strip_junk(str)
    str.gsub(/\t|\r|\n/,'').downcase
  end

  def clean_date(report)
    date = report[:date].split(',').drop(1).join(' ')
    return "#{date} #{report[:time]}"
  end

  def slug_me(str)
    str = str.downcase.strip
    str = str.gsub(/\.|:|\(|\)/,'')
    str = str.gsub(' ','_')
    return str.to_sym
  end
end
