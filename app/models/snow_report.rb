class SnowReport < ActiveRecord::Base
  validates_presence_of :report_time, :area_id
  belongs_to :area
  before_create :set_first
  after_create :send_notifications
  has_many :alerts
  scope :for_date, lambda{|date| where("report_time between ? and ?",date.beginning_of_day,date.end_of_day).order('report_time')}
  
  def shout
    send_notifications
  end

  def send_notifications
    if self.first_report 
      subscriptions = Subscription.for_inches_area(self.snowfall_twelve,self.area_id)
      subscriptions.each do |s|
        self.alerts.create(:shredder_id => s.shredder_id, :area_id => self.area_id, :subscription_id => s.id)
      end
    end
  end

  private

  def set_first
    reports = SnowReport.for_date(self.report_time)
    self.first_report = reports.empty?
    return true
  end
  
end
