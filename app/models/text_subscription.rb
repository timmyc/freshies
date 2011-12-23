class TextSubscription < Subscription
  belongs_to :shredder
  belongs_to :area

  def description
    return "Powder Alert"
  end
end
