class Alertdate < ActiveRecord::Migration
  def up
    add_column :alerts, :date_sent, :date
    add_column :subscriptions, :hour, :int
    add_index :alerts, :date_sent
    add_index :subscriptions, :hour
    Alert.all.each do |alert|
      next unless alert.snow_report
      alert.update_attribute('date_sent', alert.snow_report.report_time.to_date)
    end
  end

  def down
    remove_column :alerts, :date_sent
    remove_column :subscriptions, :hour
  end
end
