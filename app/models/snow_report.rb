class SnowReport < ActiveRecord::Base
  validates_presence_of :report_time, :area_id
  belongs_to :area
  before_create :set_first
  after_create :send_notifications
  scope :for_date, lambda{|date| where("report_time between ? and ?",date.beginning_of_day,date.end_of_day).order('report_time')}
  
  def shout
    send_notifications
  end

  private

  def set_first
    reports = SnowReport.for_date(self.report_time)
    self.first_report = reports.empty?
    return true
  end

  def send_notifications
    if self.first_report && self.snowfall_twelve && self.snowfall_twelve > 0
      shredders = Shredder.notices_for(self.snowfall_twelve,self.area_id)
      shredders.each do |s|
        Twilio.connect(Cone::Application.config.twilio_sid, Cone::Application.config.twilio_auth)
        Twilio::Sms.message(Cone::Application.config.twilio_number, s.mobile, "POWDER ALERT!  #{self.area.name} is reporting #{self.snowfall_twelve} inches in the last 12 hours - Report Time: #{self.report_time.strftime("%H:%M %m-%d-%y")}")
      end
    end
  end
end
