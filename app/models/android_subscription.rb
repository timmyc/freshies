class AndroidSubscription < Subscription
  belongs_to :shredder
  belongs_to :area

  def description
    return "Android GCM Alert"
  end

  def message_length
    2000
  end

  def update_from_app(params)
    self.update_attributes(
      :active => params[:active] == 'true' ? true : false,
      :inches => params[:inches]
    )
  end

  def send_message(alert)
    report = alert.snow_report
    message = Mustache.render(self.message, report.alert_attributes)
    gcm = GCM.new(Cone::Application.config.gcm_key)
    registration_ids= [self.shredder.gcm_id]
    options = {data: {message: message}, collapse_key: "updated_score"}
    response = gcm.send_notification(registration_ids, options)
  end
end
