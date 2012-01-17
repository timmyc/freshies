class Alert < ActiveRecord::Base
  belongs_to :snow_report
  belongs_to :area
  belongs_to :shredder
  belongs_to :subscription
  before_create :set_defaults
  after_create :deliver

  scope :for_subscription_date, lambda{|date,subscription_id| where("date_sent = ? and subscription_id = ?", date, subscription_id)}
  scope :for_area_date, lambda{|date,area_id| where("date_sent = ? and area_id = ?", date, area_id)}

  def deliver
    Delayed::Job.enqueue Dispatch.new(self.id)
  end

  def send_message
    return if self.sent?
    self.subscription.send_message(self)
    self.update_attribute('sent',true)
  end

  def set_defaults
    self.date_sent = Time.now.to_date
  end
end
