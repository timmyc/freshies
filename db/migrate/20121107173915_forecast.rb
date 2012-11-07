class Forecast < ActiveRecord::Migration
  def change
    create_table :forecasts do |t|
      t.integer :area_id
      t.string :snowfall
      t.integer :snowfall_min
      t.integer :snowfall_max
      t.timestamps
    end
    add_column :alerts, :forecast_id, :integer
  end
end
