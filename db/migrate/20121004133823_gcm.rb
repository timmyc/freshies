class Gcm < ActiveRecord::Migration
  def change
    add_column :shredders, :gcm_id, :string
  end
end
