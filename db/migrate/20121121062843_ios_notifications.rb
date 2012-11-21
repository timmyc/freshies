class IosNotifications < ActiveRecord::Migration
  def change
    add_column :shredders, :push_token, :string
  end
end
