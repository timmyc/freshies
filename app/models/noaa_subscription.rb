class NoaaSubscription < Subscription
  belongs_to :shredder
  belongs_to :area

  def description
    return "NOAA Alert"
  end

  def message_length
    130
  end

  def send_message(alert)
    forecast = alert.forecast
    message = Mustache.render(self.message, forecast.alert_attributes)
    from_number = alert.number ? alert.number.inbound : Cone::Application.config.twilio_number
    twilio_client = Twilio::REST::Client.new(Cone::Application.config.twilio_sid, Cone::Application.config.twilio_auth)
    twilio_account = twilio_client.accounts.get(area.twilio_account)
    twilio_account.sms.messages.create(:from => from_number, :to => self.shredder.mobile, :body => message)
  end
end
