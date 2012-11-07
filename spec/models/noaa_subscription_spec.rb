require 'spec_helper'

describe NoaaSubscription do
  include ShredderHelper
  it{ should belong_to(:area) }
  it{ should belong_to(:shredder) }
  it{ should have_many(:alerts) }
  
  before do
    stub_twilio_confirmation
    @shredder = FactoryGirl.create(:shredder)
    @shredder.mobile_confirm
    @noaa_subscription = @shredder.noaa_subscriptions.create(:area_id => @shredder.area_id, :active => true, :inches => 4,:message => 'NOAA is forecasting {{snowfall_min}}={{snowfall_max}}" over the next 24 hours at {{area}}')
  end

  context 'scopes' do
    it 'should return an array of subscriptions that match area inches criteria' do
      NoaaSubscription.for_inches_area(4,@shredder.area_id).size.should eql(1)
    end
  end

  it "should have a description" do
    @noaa_subscription.should respond_to(:description)
  end

  it "should respond to message_length" do
    @noaa_subscription.should respond_to(:message_length)
  end

  it "should have the correct message_length" do
    @noaa_subscription.message_length.should eql(130)
  end

  context 'send_message' do
    it "should send the correct alert body" do
      @forecast = FactoryGirl.create(:forecast, :snowfall => 4, :area_id => @shredder.area_id)
      @alert = Alert.last
      stub_twilio_sms({:from => Cone::Application.config.twilio_number, :to => @shredder.mobile, :body => "NOAA is forecasting #{@forecast.snowfall_min}=#{@forecast.snowfall_max}\" over the next 24 hours at #{@noaa_subscription.area.name}"})
      @noaa_subscription.send_message(@alert)
    end
    
    it 'should use the number attatched to the alert to send the message' do
      @number = @shredder.area.numbers.create(:inbound => '+15558675309')
      @forecast = FactoryGirl.create(:forecast, :snowfall => 4, :area_id => @shredder.area_id)
      @alert = Alert.last
      @alert.update_attribute('number_id', @number.id)
      stub_twilio_sms({:from => '+15558675309', :to => @shredder.mobile, :body => "NOAA is forecasting #{@forecast.snowfall_min}=#{@forecast.snowfall_max}\" over the next 24 hours at #{@noaa_subscription.area.name}"})
      @noaa_subscription.send_message(@alert)
    end
  end
end
