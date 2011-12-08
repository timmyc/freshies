class CreateSnowReports < ActiveRecord::Migration
  def change
    create_table :snow_reports do |t|
      t.datetime :report_time
      t.integer :snowfall_twelve
      t.integer :snowfall_twentyfour
      t.integer :snowfall_seventytwo
      t.integer :base_temp
      t.integer :mid_temp
      t.integer :summit_temp
      t.integer :base_depth
      t.integer :mid_depth

      t.timestamps
    end
  end
end
