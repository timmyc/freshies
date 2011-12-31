class Alert < ActiveRecord::Base
  belongs_to :snow_report
  belongs_to :area
  belongs_to :shredder
  belongs_to :subscription
  after_create :deliver

  def deliver
    Delayed::Job.enqueue Dispatch.new(self.id)
  end

  def send_message
    return if self.sent?
    self.subscription.send_message(self)
    self.update_attribute('sent',true)
  end
end
