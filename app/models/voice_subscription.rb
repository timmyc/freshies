class VoiceSubscription < Subscription
  INTROS = ['kids']

  def self.intros
    return INTROS
  end

  def description
    return "Voice Powder Alert"
  end

  def send_message(report)
    Twilio.connect(Cone::Application.config.twilio_sid, Cone::Application.config.twilio_auth)
    Twilio::Call.make(Cone::Application.config.twilio_number, self.shredder.mobile, "http://conepatrol.com/greetings/#{self.id}")
  end
end
