class Alert < ActiveRecord::Base
  belongs_to :snow_report
  belongs_to :area
  belongs_to :shredder

  def send_message
    return if self.sent
    report = self.snow_report
    Twilio.connect(Cone::Application.config.twilio_sid, Cone::Application.config.twilio_auth)
    Twilio::Sms.message(Cone::Application.config.twilio_number, self.shredder.mobile, "POWDER ALERT!  #{report.area.name} is reporting #{report.snowfall_twelve} inches in the last 12 hours, Base Temp: #{report.base_temp}. - Report Time: #{report.report_time.strftime("%H:%M %m-%d-%y")} ")
    self.update_attribute('sent',true)
  end
end
