class LastRide < ActiveRecord::Migration
  def change
    add_column :passes, :last_chair, :string
    add_column :passes, :last_chair_time, :datetime
    add_index :passes, :last_chair_time
  end
end
