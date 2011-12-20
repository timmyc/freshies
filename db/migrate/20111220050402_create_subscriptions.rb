class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :shredder_id
      t.integer :area_id
      t.integer :inches
      t.string :type
      t.text :message
      t.boolean :active

      t.timestamps
    end

  end
end
