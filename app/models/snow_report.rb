class SnowReport < ActiveRecord::Base
  validates_presence_of :report_time, :area_id
  belongs_to :area
  before_create :set_first
  after_create :send_notifications
  scope :for_date, lambda{|date| where("report_time between ? and ?",date.beginning_of_day,date.end_of_day).order('report_time')}

  private

  def set_first
    reports = SnowReport.for_date(self.report_time)
    self.first_report = reports.empty?
    return true
  end

  def send_notifications
    if self.first_report && self.snowfall_twelve && self.snowfall_twelve > 0
      shredders = Shredder.notices_for(self.snowfall_twelve,self.area_id)
    end
  end
end
