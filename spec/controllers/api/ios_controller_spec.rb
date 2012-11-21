require 'spec_helper'

describe Api::IosController do

  describe "GET" do
    before do
      @gcm_id = 'super-duper-de-longo-id'
    end
    
    it "should create a shredder" do
      lambda{
        post 'create', :area_id => 1, :gcm_id => @gcm_id, :active => 'true', :inches => '4'
      }.should change(Shredder, :count).by(1)
    end

    it "should create an IOS Subscription" do
      lambda{
        post 'create', :area_id => 1, :gcm_id => @gcm_id, :active => 'true', :inches => '4'
      }.should change(IosSubscription, :count).by(1)
      @ios = IosSubscription.last
      @ios.inches.should eql(4)
      @ios.active.should be_true
    end

    it "should not create a new shredder for same gcm" do
      post 'create', :area_id => 1, :gcm_id => @gcm_id, :active => 'true', :inches => '4'
      lambda{
        post 'create', :area_id => 1, :gcm_id => @gcm_id, :active => 'true', :inches => '4'
      }.should_not change(Shredder, :count)
    end

    it "should not create a new subscription for same gcm" do
      post 'create', :area_id => 1, :gcm_id => @gcm_id, :active => 'true', :inches => '4'
      lambda{
        post 'create', :area_id => 1, :gcm_id => @gcm_id, :active => 'true', :inches => '4'
      }.should_not change(IosSubscription, :count)
    end

    it "should change inches" do
      @shredder = Shredder.find_or_create_from_android(:area_id => 1, :gcm_id => @gcm_id, :push_token => @gcm_id, :active => 'true', :inches => '4')
      post 'create', :area_id => 1, :gcm_id => @gcm_id, :active => 'true', :inches => '2'
      s = Shredder.find(@shredder.id)
      @sub2 = s.ios_subscriptions.first
      @sub2.inches.should eql(2)
    end
    
  end

end


