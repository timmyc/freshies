class Numbers < ActiveRecord::Migration
  def change
    create_table :numbers do |t|
      t.string :inbound
      t.integer :area_id
      t.timestamps
    end
    add_index :numbers, :inbound
    add_index :numbers, :area_id

    create_table :sms_actions do |t|
      t.integer :area_id
      t.integer :chair_id
      t.string :command
      t.string :matcher
      t.string :response
    end
    add_index :sms_actions, :area_id
    add_index :sms_actions, :command

    create_table :chairs do |t|
      t.integer :area_id
      t.string :short_code
      t.string :name
      t.string :status
      t.timestamps
    end
    add_index :chairs, :area_id

    add_column :areas, :sub_account_id, :string
    add_column :areas, :footer_text, :string
    add_column :areas, :default_snow_amount, :integer

    add_column :alerts, :number_id, :integer
    add_column :alerts, :uuid, :string
  end
end
