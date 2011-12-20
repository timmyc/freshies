class ReConfirm < ActiveRecord::Migration
  def up
    Shredder.find(:all, :conditions => {:confirmed => true}).each do |s|
      s.text_subscriptions.create(:inches => s.inches, :area_id => s.area_id, :active => true)
    end
  end

  def down
  end
end
