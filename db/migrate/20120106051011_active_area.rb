class ActiveArea < ActiveRecord::Migration
  def up
    add_column :areas, :active, :boolean, :default => true
    add_index :areas, :active
  end

  def down
    remove_column :areas, :active
  end
end
