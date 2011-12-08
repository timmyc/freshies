class CreateShredders < ActiveRecord::Migration
  def change
    create_table :shredders do |t|
      t.text :mobile
      t.text :confirmation_code
      t.integer :area_id
      t.integer :inches
      t.boolean :active, :default => false
      t.boolean :confirmed, :default => false

      t.timestamps
    end

    add_column :snow_reports, :first_report, :boolean, :default => false
  end
end
