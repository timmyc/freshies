class SnowReport < ActiveRecord::Base
  validates_presence_of :report_time, :area_id
  belongs_to :area
  before_create :set_first
  after_create :send_notifications
  has_many :alerts
  scope :for_date_area, lambda{|date,area_id| where("report_time between ? and ? and area_id = ?",date.beginning_of_day,date.end_of_day,area_id).order('report_time')}
  
  def shout
    send_notifications
  end

  def send_notifications
    subscriptions = Subscription.for_inches_area(self.snowfall_twelve,self.area_id)
    alerts_sent = Alert.for_area_date(self.report_time.to_date, self.area_id).collect{|a| a.subscription_id }
    numbers = self.area.numbers
    number_counter = 0
    subscriptions.each do |s|
      next if alerts_sent.include?(s.id) || ['NoaaSubscription'].include?(s.class.name)
      number = numbers.empty? ? nil : numbers[number_counter%numbers.length]
      number_counter += 1
      self.alerts.create(:shredder_id => s.shredder_id, :area_id => self.area_id, :subscription_id => s.id, :number => number)
    end
  end

  def alert_attributes
    return { :area => self.area.name, :new_snow => self.snowfall_twelve, :base_depth => self.base_depth, :mid_depth => self.mid_depth, :base_temp => self.base_temp, :mid_temp => self.mid_temp, :summit_temp => self.summit_temp, :report_time => self.report_time.strftime("%H:%M %m-%d-%y") }
  end

  private

  def set_first
    reports = SnowReport.for_date_area(self.report_time,self.area_id)
    self.first_report = reports.empty?
    return true
  end
  
end
