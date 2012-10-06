require 'spec_helper'

describe Api::AndroidController do

  describe "GET" do
    before do
      @gcm_id = 'super-duper-de-longo-id'
    end
    
    it "should create a new shredder" do
      lambda{
        get 'index', :area_id => 1, :gcm_id => @gcm_id, :active => 'true', :inches => '4'
      }.should change(Shredder,:count).by(1)
    end

    it "should deactive subscription" do
      @shredder = Shredder.find_or_create_from_android(:area_id => 1, :gcm_id => @gcm_id, :active => 'true', :inches => '4')
      @sub = @shredder.android_subscriptions.first
      get 'index', :area_id => 1, :gcm_id => @gcm_id, :active => 'false', :inches => '4'
      @sub2 = AndroidSubscription.find(@sub)
      @sub2.active.should be_false
    end

    it "should change inches" do
      @shredder = Shredder.find_or_create_from_android(:area_id => 1, :gcm_id => @gcm_id, :active => 'true', :inches => '4')
      @sub = @shredder.android_subscriptions.first
      get 'index', :area_id => 1, :gcm_id => @gcm_id, :active => 'true', :inches => '2'
      @sub2 = AndroidSubscription.find(@sub)
      @sub2.inches.should eql(2)
    end
    
  end

end


