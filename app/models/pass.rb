class Pass < ActiveRecord::Base
  attr_accessible :pass_number, :total_veritcal_feet, :total_runs, :total_days
  belongs_to :shredder

  def update_stats
    tyt = Tyt.const_get(shredder.area.klass).new(:pass => pass_number)
    season_data = tyt.season_data
    self.update_attributes(
      :total_runs => season_data.total_days,
      :total_vertical_feet => season_data.total_vertical_feet,
      :total_runs => season_data.total_runs
    )
  end
end
