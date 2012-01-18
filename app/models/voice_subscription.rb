class VoiceSubscription < Subscription
  GENDERS = ['male','female']
  INTROS = ['kids','cant-touch-this','dont-stop','paradise-city','rocky-theme','tunak-tunak','waiting-room']
  validates_inclusion_of :gender, :in => GENDERS 
  validates_inclusion_of :intro, :in => INTROS, :allow_nil => true
  validates_uniqueness_of :area_id, :scope => :shredder_id, :message => 'is already being used in another one of your subscriptions'

  def self.intros
    return INTROS
  end

  def self.genders
    return GENDERS
  end

  def description
    return "Voice Alert"
  end

  def message_length
    330
  end

  def send_message(alert)
    Twilio.connect(Cone::Application.config.twilio_sid, Cone::Application.config.twilio_auth)
    Twilio::Call.make(Cone::Application.config.twilio_number, self.shredder.mobile, "http://conepatrol.com/greetings/#{alert.id}")
  end
end
