require 'spec_helper'

describe Area do
  it{ should validate_presence_of(:name) }
  it{ should validate_presence_of(:twitter) }
  it{ should validate_presence_of(:klass) }
  it{ should have_many(:snow_reports) }
  it{ should have_many(:numbers) }
  it{ should have_many(:shredders) }
  it{ should have_many(:alerts) }
  it{ should have_many(:subscriptions) }
  it{ should have_many(:chairs) }
  it{ should respond_to(:sub_account_id) }
  it{ should respond_to(:footer_text) }

  describe 'secret' do
    before do
      @area = FactoryGirl.create(:area)
    end

    it "should auto generate" do
      @area.secret.empty?.should be_false
    end

    it "should be 18 chars long" do
      @area.secret.length.should eql(18)
    end
  end

  describe 'sms_message' do
    before do
      @area = FactoryGirl.create(:area)
    end

    it 'should use default message' do
      @area.sms_message.should eql('{{area}} is reporting {{new_snow}}" of new snow. Base Temp: {{base_temp}}. Reported At: {{report_time}}')
    end

    it 'should use the custom message' do
      @template = '{{area}} is reporting {{new_snow}}" of new snow.'
      @area.update_attribute('sms_template',@template)
      @area.sms_message.should eql(@template)
    end
  end

  describe 'key' do
    before do
      @area = FactoryGirl.create(:area)
    end
    
    it "should auto generate" do
      @area.key.empty?.should be_false
    end

    it "should be 6 chars long" do
      @area.key.length.should eql(6)
    end
  end

  context 'create_forecast' do
    before do
      @area = FactoryGirl.create(:area)
    end
    it{ should respond_to(:get_forecast) }
    it 'should create an ullr instance' do
      @ullr = mock(Ullr::Forecast)
      @ullr.should_receive(:get_noaa_forecast).and_return([OpenStruct.new(:snow_estimate => ["0", "1"]), OpenStruct.new(:snow_estimate => ["2", "4"])])
      Ullr::Forecast.should_receive(:new).with(:lat => @area.latitude.to_f, :lon => @area.longitude.to_f).and_return(@ullr)
      @area.get_forecast.should eql([["0","1"],["2","4"]])
    end

    it{ should respond_to(:create_forecast) }
    it 'should create a forecast' do
      @area.should_receive(:get_forecast).and_return([["0","1"],["2","4"]])
      expect{
        @area.create_forecast
      }.to change(@area.forecasts, :size).by(1)
      forecast = @area.forecasts.last
      forecast.snowfall_min.should eql(2)
      forecast.snowfall_max.should eql(5)
      forecast.snowfall.should eql(2)
    end
  end

  describe 'twilio sub account' do
    it{ should respond_to(:sub_account_id) }
    it{ should respond_to(:twilio_account) }
    it 'should return default twilio account when no sub account set' do
      @area = FactoryGirl.create(:area, :sub_account_id => nil)
      @area.twilio_account.should eql(Cone::Application.config.twilio_sid)
    end
    it 'should return the sub_account_id if present' do
      @area = FactoryGirl.create(:area, :sub_account_id => 'omgrad')
      @area.twilio_account.should eql('omgrad')
    end
  end

end
