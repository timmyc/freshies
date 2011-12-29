class TextSubscription < Subscription
  belongs_to :shredder
  belongs_to :area

  def description
    return "Powder Alert"
  end

  def send_message(report)
    Twilio.connect(Cone::Application.config.twilio_sid, Cone::Application.config.twilio_auth)
    Twilio::Sms.message(Cone::Application.config.twilio_number, self.shredder.mobile, "POWDER ALERT!  #{self.area.name} is reporting #{report.snowfall_twelve} inches in the last 12 hours, Base Temp: #{report.base_temp}. - Report Time: #{report.report_time.strftime("%H:%M %m-%d-%y")} ")
  end
end
