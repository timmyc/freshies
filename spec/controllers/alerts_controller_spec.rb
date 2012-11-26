require 'spec_helper'

describe AlertsController do
  include ShredderHelper

  describe "GET" do
    before do
      @area = FactoryGirl.create(:area)
      stub_twilio_confirmation
      @shredder = FactoryGirl.create(:shredder, :area => @area)
      @area.update_attribute('sms_link','http://mtbachelor.com')
      @shredder.mobile_confirm
      @voice_subscription = @shredder.voice_subscriptions.create(:area_id => @area.id, :inches => 4, :active => true, :message => 'omg it snowed {{new_snow}} inches and it is {{base_temp}} at the base!', :gender => 'male')
      @snow_report = FactoryGirl.create(:snow_report, :snowfall_twelve => 10, :area => @area, :report_time => Time.now, :base_temp => 28)
    end
    
    it "should serve up proper twiml" do
      @alert = @voice_subscription.alerts.first
      get 'answer', :id => @alert.id
      response.should be_success
      xml = ActiveResource::Formats::XmlFormat.decode(response.body)
      xml['Say'].should eql("omg it snowed 10 inches and it is 28 at the base!")
    end

    context 'in linker' do
      it "should 404 on invalid uuid" do
        expect{
          get 'in', :id => 111
        }.to raise_error(ActionController::RoutingError)
      end

      it "should change the alert clicked boolean" do
        @alert = @voice_subscription.alerts.first
        get 'in', :id => @alert.uuid
        alert = Alert.find(@alert.id)
        alert.clicked.should be_true
        response.code.should eql('301')
      end
    end
  end

end

