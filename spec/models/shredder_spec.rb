require 'spec_helper'

describe Shredder do
  include ShredderHelper
  it{ should validate_presence_of(:mobile) }
  it{ should validate_presence_of(:area_id) }
  it{ should validate_presence_of(:inches) }
  it{ should validate_numericality_of(:inches) }
  it{ should belong_to(:area) }
  it{ should have_many(:alerts) }
  it{ should have_many(:subscriptions) }
  it{ should have_many(:text_subscriptions) }
  it{ should have_many(:voice_subscriptions) }
  it{ should have_many(:android_subscriptions) }
  it{ should have_many(:ios_subscriptions) }
  it{ should have_many(:noaa_subscriptions) }
  it{ should have_many(:passes) }
  
  context 'SMS Shredders' do
    before do
      #man I am no good at mocking stuff
      @area = FactoryGirl.create(:area)
      stub_twilio_confirmation
      @shredder = FactoryGirl.create(:shredder, :area_id => @area.id)
    end
  
    it "should auto-create a confirmation_code" do
      @shredder.confirmation_code.empty?.should be_false
    end

    it "should respond to confirm" do
      @shredder.should respond_to(:mobile_confirm)
    end

    it "should respond to active" do
      @shredder.should respond_to(:active)
    end

    it "should be inactive by default" do
      @shredder.active.should be_false
    end

    it "should give a random name" do
      @shredder.should respond_to(:random_name)
    end

    it "should have a helper for active subscriptions" do
      @shredder.should respond_to(:active_subscriptions)
    end

    it "should return the correct number of active subscriptions" do
      @shredder.active_subscriptions.should eql([])
    end

    it "should return the correct number of active subscriptions" do
      @shredder.mobile_confirm
      @shredder.active_subscriptions.size.should eql(1)
    end

    context 'mobile_confirm' do
      it "should auto-create a subscription on confirm" do
        expect{ @shredder.mobile_confirm }.to change(@shredder.text_subscriptions, :length).from(0).to(1)
      end
    end

    context 'devise confirm' do
      [:confirmation_token,:confirmed_at,:confirmation_sent_at,:confirmation_token].each do |s|
        it "should respond to #{s.to_s}" do
          @shredder.should respond_to(s)
        end
      end
    end
  end

  context 'should_validate_mobile' do
    it 'should be false if gcm_id set' do
      @shredder = Shredder.new
      @shredder.gcm_id = 'super'
      @shredder.should_validate_mobile.should be_false
    end
    it 'should be true if gcm_id is not set' do
      @shredder = Shredder.new
      @shredder.should_validate_mobile.should be_true
    end
  end
  
  context 'gcm_id' do
    it 'should respond to' do
      @shredder = Shredder.new
      @shredder.should respond_to(:gcm_id)
    end
  end

  context 'Push Shredders' do
    before do
      @params = {:area_id => 1, :gcm_id => 'superduperlongrandomstring', :inches => '4'}
    end
    it 'should have a class method to create gcm shredders' do
      Shredder.should respond_to(:find_or_create_from_android)
    end
    it 'should not send a confirmation when a new shredder is created' do
      Twilio::REST::Client.should_not_receive(:new)
      lambda{
        shredder = Shredder.find_or_create_from_android(@params)
      }.should change(Shredder,:count).by(1)
    end
    it 'should not create a new shredder if one exists for gcm_id' do
      shredder = Shredder.find_or_create_from_android(@params)
      lambda{
        Shredder.find_or_create_from_android(@params)
      }.should_not change(Shredder,:count)
    end
    it 'should create an android subscription' do
      lambda{
        Shredder.find_or_create_from_android(@params)
      }.should change(AndroidSubscription,:count).by(1)

    end
  end

  context 'SMS Only Shredders' do
    before do
      @area = FactoryGirl.create(:area)
      @params = {:area_id => @area.id, :mobile => '+15413503333', :inches => '4'}
    end
    it 'should have a class method to create sms only shredders' do
      Shredder.should respond_to(:find_or_create_by_number_area)
    end
    it 'should not send a confirmation when a new shredder is created' do
      Twilio::REST::Client.should_not_receive(:new)
      lambda{
        shredder = Shredder.find_or_create_by_number_area(@params)
      }.should change(Shredder,:count).by(1)
    end
    it 'should not create a new shredder if one exists for gcm_id' do
      shredder = Shredder.find_or_create_by_number_area(@params)
      lambda{
        Shredder.find_or_create_by_number_area(@params)
      }.should_not change(Shredder,:count)
    end
    it 'should create a text subscription' do
      lambda{
        Shredder.find_or_create_by_number_area(@params)
      }.should change(TextSubscription,:count).by(1)

    end
  end

end
