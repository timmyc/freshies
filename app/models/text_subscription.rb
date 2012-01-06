class TextSubscription < Subscription
  belongs_to :shredder
  belongs_to :area
  validates_uniqueness_of :area_id, :scope => :shredder_id, :message => 'is already being used in another one of your subscriptions'

  def description
    return "Text Alert"
  end

  def message_length
    130
  end

  def send_message(alert)
    report = alert.snow_report
    message = Mustache.render(self.message, report.alert_attributes)
    Twilio.connect(Cone::Application.config.twilio_sid, Cone::Application.config.twilio_auth)
    Twilio::Sms.message(Cone::Application.config.twilio_number, self.shredder.mobile, message)
  end
end
