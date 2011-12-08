class AreaSnowReports < ActiveRecord::Migration
  def up
    add_column :snow_reports, :area_id, :integer
    add_index :snow_reports, :area_id
    add_index :snow_reports, :report_time
  end

  def down
    remove_column :snow_reports, :area_id
    remove_index :snow_reports, :report_time
  end
end
