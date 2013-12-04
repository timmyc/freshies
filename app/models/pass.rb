class Pass < ActiveRecord::Base
  attr_accessible :pass_number, :total_veritcal_feet, :total_runs, :total_days, :last_chair, :last_chair_time
  belongs_to :shredder

  def update_stats
    season_data = get_season_data
    self.total_runs = season_data.total_runs
    self.total_vertical_feet = season_data.total_vertical_feet
    self.total_days = season_data.total_days
    self.save
  end

  def update_last_chair
    last_day = get_last_ride
    self.last_chair_time = last_day.datetime
    self.last_chair = last_day.chair
    self.save
    return last_day
  end

  def skied_on?(date)
    get_season_data.days.detect{|sd| sd.date == date }
  end

  def get_last_ride
    season_data = get_season_data
    if season_data.days.empty?
      return nil
    else
      return @tyt.date_data(season_data.days.last.date).last
    end
  end

  def get_season_data
    @tyt ||= Tyt.const_get(shredder.area.klass).new(:pass => pass_number)
    return @tyt.season_data
  end

  def send_day_stats(ski_day,area)
    from_number = area.default_number
    twilio_client = Twilio::REST::Client.new(Cone::Application.config.twilio_sid, Cone::Application.config.twilio_auth)
    twilio_account = twilio_client.accounts.get(area.twilio_account)
    message = "Track Your Turns: #{ski_day.runs} runs #{ski_day.vertical_feet}' vertical feet"
    twilio_account.sms.messages.create(:from => from_number, :to => self.shredder.mobile, :body => message)
  end
end
