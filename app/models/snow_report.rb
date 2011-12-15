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
      shredders = Shredder.notices_for(self.snowfall_twelve,self.area_id)
      shredders.each do |s|
        alert = Alert.find_or_create_by_snow_report_id_and_shredder_id(self.id,s.id)
        alert.send_message
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
