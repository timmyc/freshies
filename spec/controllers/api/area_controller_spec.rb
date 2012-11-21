require 'spec_helper'

describe Api::AreaController do

  describe "GET" do
    before do
      @area = FactoryGirl.create(:area)
      @snow_report = FactoryGirl.create(:snow_report, :area => @area, :report_time => Time.now)
    end

    it 'should return the latest snow report for an area' do
      get :last_report, :id => @area.key
      response.response_code.should == 200
      body = parse_json(response.body)
      body['snowfall_twelve'].should eql(2)
    end
    
    
  end

end


