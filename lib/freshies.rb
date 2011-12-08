require "net/http"
require "uri"

class Freshies
  attr_accessor :endpoint
  attr_accessor :areas
  
  def initialize
    @endpoint = 'http://gentle-autumn-1698.herokuapp.com/snow_reports'
    @areas = [{
      :key => ENV['MTB_KEY'], :secret => ENV['MTB_SECRET']
    }]
  end

  def process
    uri = URI.parse(@endpoint)
    @areas.each do |area|
      response = Net::HTTP.post_form(uri, {'key' => area[:key], 'secret' => area[:secret]})
      puts response
    end
  end
end

robot = Freshies.new
robot.process
