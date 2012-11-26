class SuperAdmin < ActiveRecord::Migration
  def change
    add_column :areas, :sms_link, :string
    add_column :areas, :sms_template, :string
    add_column :admin_users, :super_duper, :boolean, :default => false
    add_column :alerts, :clicked, :boolean, :default => false
  end
end
