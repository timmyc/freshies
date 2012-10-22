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
    from_number = alert.number ? alert.number.inbound : Cone::Application.config.twilio_number
    twilio_client = Twilio::REST::Client.new(Cone::Application.config.twilio_sid, Cone::Application.config.twilio_auth)
    twilio_account = twilio_client.accounts.get(area.twilio_account)
    twilio_account.sms.messages.create(:from => from_number, :to => self.shredder.mobile, :body => message)
  end
end
