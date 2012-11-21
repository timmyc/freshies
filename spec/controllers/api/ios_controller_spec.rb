require 'spec_helper'

describe Api::IosController do

  describe "GET" do
    before do
      @gcm_id = 'super-duper-de-longo-id'
      @push_token = 'anothersuperasslongstring'
    end
    
    it "should create a new shredder" do
      lambda{
        get 'index', :area_id => 1, :gcm_id => @gcm_id, :push_token => @push_token, :active => 'true', :inches => '4'
      }.should change(Shredder,:count).by(1)
    end

    it 'should create a shredder but not a subscription' do
      lambda{
        get 'index', :inches => '5', :push_token => @push_token, :active => 'true', :gcm_id => 'APA91bEx78omqADoQTQdWAFqaSqZEOB7pptHFCX_TLMT-W_A9N7CUT2RST3I9XfzkMwDIQkKUqRff7k0LcZW7JsP1bnI9F_J-AzFpcSE65mkuyyYupAr5vBp2FKrQ421n1xOAS24HgzjzB7DSNwwprc7WfFaGr8Cvg', :area_id => '1'
      }.should_not change(IosSubscription, :count)
    end

    it "should create subscription" do
      @shredder = Shredder.find_or_create_from_android(:area_id => 1, :gcm_id => @gcm_id, :active => 'true', :inches => '4', :push_token => @push_token)
      lambda{
        post 'create', :area_id => 1, :gcm_id => @gcm_id, :active => 'false', :inches => '4'
      }.should change(IosSubscription, :count).by(1)
    end

    it "should change inches" do
      @shredder = Shredder.find_or_create_from_android(:area_id => 1, :gcm_id => @gcm_id, :active => 'true', :inches => '4')
      get 'index', :area_id => 1, :gcm_id => @gcm_id, :active => 'true', :inches => '2'
      post 'create', :area_id => 1, :gcm_id => @gcm_id, :active => 'true', :inches => '2'
      s = Shredder.find(@shredder.id)
      @sub2 = s.ios_subscriptions.first
      @sub2.inches.should eql(2)
    end
    
  end

end


