class Forecast < ActiveRecord::Base
  validates_presence_of :area_id
  belongs_to :area
  after_create :send_notifications
  has_many :alerts
  
  def shout
    send_notifications
  end

  def send_notifications
    subscriptions = NoaaSubscription.for_inches_area(self.snowfall,self.area_id)
    numbers = self.area.numbers
    number_counter = 0
    subscriptions.each do |s|
      number = numbers.empty? ? nil : numbers[number_counter%numbers.length]
      number_counter += 1
      self.alerts.create(:shredder_id => s.shredder_id, :area_id => self.area_id, :subscription_id => s.id, :number => number)
    end
  end

  def alert_attributes
    return { :area => self.area.name, :snowfall => self.snowfall, :snowfall_min => self.snowfall_min, :snowfall_max => self.snowfall_max }
  end

end
