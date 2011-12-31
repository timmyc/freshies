class VoiceSubscription < Subscription
  GENDERS = ['male','female']
  INTROS = ['kids']
  validates_inclusion_of :gender, :in => GENDERS 
  validates_inclusion_of :intro, :in => INTROS, :allow_nil => true

  def self.intros
    return INTROS
  end

  def self.genders
    return GENDERS
  end

  def description
    return "Voice Alert"
  end

  def send_message(report)
    Twilio.connect(Cone::Application.config.twilio_sid, Cone::Application.config.twilio_auth)
    Twilio::Call.make(Cone::Application.config.twilio_number, self.shredder.mobile, "http://conepatrol.com/greetings/#{self.id}")
  end
end
