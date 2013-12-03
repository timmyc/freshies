class Pass < ActiveRecord::Base
  attr_accessible :pass_number, :total_veritcal_feet, :total_runs, :total_days
  belongs_to :shredder

  def update_stats
    tyt = Tyt.const_get(shredder.area.klass).new(:pass => pass_number)
    season_data = tyt.season_data
    self.total_runs = season_data.total_days
    self.total_vertical_feet = season_data.total_vertical_feet
    self.total_runs = season_data.total_runs
    self.save
  end
end
