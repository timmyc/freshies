class VoiceStuff < ActiveRecord::Migration
  def up
    add_column :subscriptions, :intro, :string
    add_column :subscriptions, :gender, :string
    TextSubscription.all.each{|t| t.update_attribute('message','FRESHIEZ! Bachy is reporting {{new_snow}}" in the last 12 hours. Base Temp: {{base_temp}}. Reported At: {{report_time}}') }
  end

  def down
    remove_column :subscriptions, :intro
    remove_column :subscriptions, :gender
  end
end
