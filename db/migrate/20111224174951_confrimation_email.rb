class ConfrimationEmail < ActiveRecord::Migration
  def self.up
    add_column :shredders, :confirmation_token, :string
    add_column :shredders, :confirmed_at,       :datetime
    add_column :shredders, :confirmation_sent_at , :datetime

    add_index  :shredders, :confirmation_token, :unique => true
  end
  def self.down
    remove_index  :shredders, :confirmation_token

    remove_column :shredders, :confirmation_sent_at
    remove_column :shredders, :confirmed_at
    remove_column :shredders, :confirmation_token
  end
  
end
