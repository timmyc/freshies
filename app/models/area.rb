class Area < ActiveRecord::Base
  validates_presence_of :name, :klass, :twitter
  before_create :set_api_keys
  has_many :snow_reports
  has_many :shredders
  has_many :subscriptions
  has_many :alerts
  has_many :chairs
  has_many :numbers
  has_many :forecasts
  scope :active, :conditions => {:active => true}
  DEFAULT_MESSAGE = '{{area}} is reporting {{new_snow}}" of new snow. Base Temp: {{base_temp}}. Reported At: {{report_time}}'

  def generate_code(size = 6)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
    (0...size).map{ charset.to_a[rand(charset.size)] }.join
  end

  def twilio_account
    if sub_account_id
      return sub_account_id
    else
      return Cone::Application.config.twilio_sid
    end
  end

  def last_snow_report
    SnowReport.where("area_id = #{self.id}").limit(1).order('report_time desc')
  end

  def sms_message
    DEFAULT_MESSAGE
  end

  def get_forecast
    ullr = Ullr::Forecast.new(:lat => self.latitude.to_f, :lon => self.longitude.to_f)
    forecast = ullr.get_noaa_forecast
    forecast[0..1].collect{|i| i.snow_estimate }
  end

  def create_forecast
    forecast_data = get_forecast
    snowfall_min = forecast_data.inject(0){|m,f| m += f.first.to_i }
    snowfall_max = forecast_data.inject(0){|m,f| m += f.last.to_i }
    forecasts.create(:snowfall_min => snowfall_min, :snowfall_max => snowfall_max, :snowfall => snowfall_min)
  end

  private

  def set_api_keys
    self.secret = self.generate_code(18)
    self.key = self.generate_code
  end

end
