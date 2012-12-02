require 'spec_helper'

describe SnowReportsController do
  include ShredderHelper
  describe "POST" do
    before do
      @area = FactoryGirl.create(:area)
    end
    it "returns http failure without credentials" do
      post 'create'
      response.should_not be_success
    end
    it "should create a snow report with credentials" do
      stub_twitter
      lambda {
        post 'create', :key => @area.key, :secret => @area.secret
        response.should be_success
      }.should change(SnowReport, :count).from(0).to(1)    
    end
    it "should not create a new snow report if the date time are the same" do
      stub_twitter
      post 'create', :key => @area.key, :secret => @area.secret
      response.should be_success
      expect {
        post 'create', :key => @area.key, :secret => @area.secret
        response.should be_success
      }.to change(SnowReport, :count).by(0)
    end
  end

end
