require 'happymapper'
module NOAA
  
  class StartValidTime
    include HappyMapper
    tag 'start-valid-time'
    content :period_start
    attribute :'period-name', String
    set_time = lambda{|ob| ob.period_start = DateTime.parse(ob.period_start) }
    after_parse(&set_time)
  end

  class TimeLayout
    include HappyMapper
    tag 'time-layout'
    element :'layout-key', String
    has_many :start_valid_times, StartValidTime
  end

  class Value
    include HappyMapper
    content :value
  end

  class Temperature
    include HappyMapper
    tag 'temperature'
    element :name, String
    attribute :type, String
    attribute :units, String
    attribute :'time-layout', String
    has_many :values, Value
  end

  class POP
    include HappyMapper
    tag 'probability-of-precipitation'
    element :name, String
    attribute :type, String
    attribute :units, String
    attribute :'time-layout', String
    has_many :values, Value
  end

  class WeatherCondition
    include HappyMapper
    tag 'weather-conditions'
    attribute :'weather-summary', String
  end

  class Weather
    include HappyMapper
    tag 'weather'
    attribute :'time-layout', String
    element :name, String
    has_many :weather_conditions, WeatherCondition
  end

  class IconLink
    include HappyMapper
    tag 'icon-link'
    content :url
  end

  class ConditionsIcon
    include HappyMapper
    tag 'conditions-icon'
    attribute :'time-layout', String
    element :name, String
    has_many :icon_links, IconLink
  end

  class Text
    include HappyMapper
    tag 'text'
    content :value

    def has_snow?
      if self.value =~ /snow/i
        return true
      else
        return false
      end
    end

    def snow_estimate
      rng = []
      range = self.value.scan(/New snow accumulation of ([0-9]|[0-9][0-9]) to ([0-9]|[0-9][0-9]) inches possible/)
      one = self.value.scan(/around an inch possible/)
      if !one.empty?
        rng = ['0','1']
      elsif !range.empty?
        rng = range
      end
      return rng
    end
  end

  class WordedForecast
    include HappyMapper
    tag 'wordedForecast'
    attribute :'time-layout', String
    attribute :dataSource, String
    attribute :wordGenerator, String
    element :name, String
    has_many :texts, Text
  end

  class Parameters
    include HappyMapper
    tag 'parameters'
    has_many :temperatures, Temperature
    has_many :pops, POP
    has_one :weather, Weather
    has_one :conditions_icon, ConditionsIcon
    has_one :worded_forecast, WordedForecast
  end

end
