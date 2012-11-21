class IosSubscription < Subscription
  belongs_to :shredder
  belongs_to :area

  def description
    return "IOS Push Notification"
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
    APNS.pem = Cone::Application.config.apns_pem_path
    APNS.send_notification(self.shredder.push_token,message)
  end
end
