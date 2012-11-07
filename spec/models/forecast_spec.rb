require 'spec_helper'

describe Forecast do
  include ShredderHelper
  it{ should belong_to(:area) }
  it{ should have_many(:alerts) }
  it{ should validate_presence_of(:area_id) }
  before do
    @area = FactoryGirl.create(:area)
    stub_twilio_confirmation
    @shredder = FactoryGirl.create(:shredder, :area => @area)
    @shredder.mobile_confirm
    @noaa_subscription = FactoryGirl.create(:noaa_subscription, :shredder_id => @shredder.id, :area_id => @area.id, :inches => 4, :active => true)
    @forecast = FactoryGirl.build(:forecast, :snowfall => 4, :area => @area)
  end

  it "should return a hash of alert attributes" do
    @forecast.alert_attributes.should be_an_instance_of(Hash)
  end

  it "should set the correct area on alert attributes" do
    @forecast.alert_attributes[:area].should eql(@area.name)
  end

  it "should create alerts when subscriptions exist" do
    expect{
      @forecast.save
    }.to change(Alert,:count).by(1)
  end

  it "should only create alerts when subscriptions with proper snow threshold exist" do
    stub_twilio_confirmation
    @shredder2 = FactoryGirl.create(:shredder, :area => @area)
    @shredder2.mobile_confirm
    @noaa_subscription2 = FactoryGirl.create(:noaa_subscription, :active => true, :shredder => @shredder, :area => @area, :inches => 2)
    expect{
      @forecast.save
    }.to change(Alert,:count).by(2)
  end

end
