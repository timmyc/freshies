class CreatePasses < ActiveRecord::Migration
  def change
    create_table :passes do |t|
      t.integer :shredder_id
      t.string :pass_number
      t.integer :total_vertical_feet, :default => 0
      t.integer :total_days, :default => 0
      t.integer :total_runs, :default => 0
      t.timestamps
    end
  end
end
