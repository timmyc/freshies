class TextSubscription < Subscription
  belongs_to :shredder
  belongs_to :area

  def description
    return "Powder Alert"
  end

  def send_message(report)
    message = Mustache.render(self.message, report.alert_attributes)
    Twilio.connect(Cone::Application.config.twilio_sid, Cone::Application.config.twilio_auth)
    Twilio::Sms.message(Cone::Application.config.twilio_number, self.shredder.mobile, message)
  end
end
