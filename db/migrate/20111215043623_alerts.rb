class Alerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer :shredder_id
      t.integer :snow_report_id
      t.integer :area_id
      t.boolean :sent, :default => false
      t.timestamps
    end
  end
end
