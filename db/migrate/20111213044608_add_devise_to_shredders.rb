class AddDeviseToShredders < ActiveRecord::Migration
  def self.up
    change_table(:shredders) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
    end

    add_index :shredders, :reset_password_token, :unique => true
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
