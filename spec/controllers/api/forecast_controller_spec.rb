require 'spec_helper'

describe Api::ForecastController do

  describe "POST" do
    before do
      @area = FactoryGirl.create(:area)
    end
    
    it 'should not allow access with invalid credentials' do
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("blah:password")
      post :create
      response.response_code.should == 401
    end

    it 'should create a new forecast with valid credentials' do
      @ullr = mock(Ullr::Forecast)
      @ullr.should_receive(:get_noaa_forecast).and_return([OpenStruct.new(:snow_estimate => ["0", "1"]), OpenStruct.new(:snow_estimate => ["2", "4"])])
      Ullr::Forecast.should_receive(:new).with(:lat => @area.latitude.to_f, :lon => @area.longitude.to_f).and_return(@ullr)
      expect{
        @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{@area.key}:#{@area.secret}")
        post :create
        response.response_code.should == 200
      }.to change(Forecast, :count).by(1)
    end
  end

end


