require 'spec_helper'

describe AlertsController do

  describe "GET" do
    before do
      @area = Factory.create(:area)
      @shredder = Factory.create(:shredder, :area => @area)
      @shredder.mobile_confirm
      @voice_subscription = @shredder.voice_subscriptions.create(:area_id => @area.id, :inches => 4, :active => true, :message => 'omg it snowed {{new_snow}} inches and it is {{base_temp}} at the base!', :gender => 'male')
      @snow_report = Factory.create(:snow_report, :snowfall_twelve => 10, :area => @area, :report_time => Time.now, :base_temp => 28)
    end
    
    it "should serve up proper twiml" do
      @alert = @voice_subscription.alerts.first
      get 'answer', :id => @alert.id
      response.should be_success
      xml = ActiveResource::Formats::XmlFormat.decode(response.body)
      xml['Say'].should eql("omg it snowed 10 inches and it is 28 at the base!")
    end
    
  end

end

