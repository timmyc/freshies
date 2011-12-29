class AlertSubscription < ActiveRecord::Migration
  def up
    add_column :alerts, :subscription_id, :int
  end

  def down
    remove_column :alerts, :subscription_id
  end
end
