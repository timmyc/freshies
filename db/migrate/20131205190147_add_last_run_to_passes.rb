class AddLastRunToPasses < ActiveRecord::Migration
  def change
    add_column :passes, :last_run, :datetime
    add_column :passes, :real_time, :boolean, :default => false
  end
end
