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
  
  end
end
