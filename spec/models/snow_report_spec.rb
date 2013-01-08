require 'spec_helper'

describe SnowReport do
  include ShredderHelper
  it{ should belong_to(:area) }
  it{ should have_many(:alerts) }
  it{ should validate_presence_of(:report_time) }
  it{ should validate_presence_of(:area_id) }
  before do
    @area = FactoryGirl.create(:area)
    stub_twilio_confirmation
    @shredder = FactoryGirl.create(:shredder, :area => @area)
    @shredder.mobile_confirm
    @snow_report = FactoryGirl.build(:snow_report, :area => @area, :report_time => Time.now)
    stub_twilio_confirmation
    @shredder2 = FactoryGirl.create(:shredder, :area => @area, :inches => 8)
    @shredder2.mobile_confirm
  end

  context "scopes" do
    it "should provide today's reports" do
      stub_twitter
      @snow_report.save
      @snow_report2 = FactoryGirl.create(:snow_report, :area => @area, :report_time => Time.now.to_date.ago(2.days))
      SnowReport.for_date_area(Time.now.to_date, @area.id).size.should eql(1)
    end
    it "should not include other areas reports" do
      stub_twitter
      @area2 = FactoryGirl.create(:area)
      @snow_report.save
      @snow_report2 = FactoryGirl.build(:snow_report, :area => @area2, :report_time => Time.now)
      SnowReport.for_date_area(Time.now.to_date, @area.id).size.should eql(1)
    end
  end

  it "should return a hash of alert attributes" do
    @snow_report.alert_attributes.should be_an_instance_of(Hash)
  end

  it "should set the correct area on alert attributes" do
    @snow_report.alert_attributes[:area].should eql(@area.name)
  end

  context "first_report" do
    it "should respond to first_report" do
      stub_twitter
      @snow_report.save
      @snow_report.respond_to?(:first_report).should be_true
    end
    it "should set first_report true if no other reports exist for this date" do
      stub_twitter
      @snow_report.save
      @snow_report.first_report.should be_true
    end
    it "should set first_report false if other reports exist for this date" do
      stub_twitter
      @snow_report.save
      @snow_report2 = FactoryGirl.create(:snow_report, :area => @area, :report_time => Time.now + 2.minutes)
      @snow_report2.first_report.should be_false
    end
    it "should not create alerts after create if first report if snowfall is 0" do
      @snow_report = FactoryGirl.build(:snow_report, :area => @area, :report_time => Time.now, :snowfall_twelve => 0)
      expect {
        @snow_report.save
      }.to change(@snow_report.alerts, :size).by(0)
    end
    it "should have the right set of shredders to notify" do
      @subscriptions = Subscription.for_inches_area(1,@area.id)
      @subscriptions.first.shredder_id.should eql(@shredder.id)
    end
    it "should be the first report" do
      stub_twitter
      @snow_report.save
      @snow_report.first_report.should be_true
    end
    it "should create alerts after create if first report if snowfall is >= 1" do
      stub_twitter
      @noaa_subscription = FactoryGirl.create(:noaa_subscription, :shredder_id => @shredder.id, :area_id => @area.id, :inches => 2, :active => true)
      @snow_report = FactoryGirl.build(:snow_report, :area => @area, :report_time => Time.now.to_date.ago(2.days), :snowfall_twelve => 2)
      expect {
        @snow_report.save
      }.to change(@snow_report.alerts, :size).by(1)
    end
    it "should not create alerts after create if alerts already sent for subscription and snowfall is >= 1" do
      stub_twitter
      @snow_report = FactoryGirl.build(:snow_report, :area => @area, :report_time => Time.now, :snowfall_twelve => 2)
      @snow_report.save
      @snow_report2 = FactoryGirl.build(:snow_report, :area => @area, :report_time => Time.now + 2.minutes, :snowfall_twelve => 2)
      expect {
        @snow_report2.save
      }.to change(@snow_report2.alerts, :size).by(0)
    end
    it "should only send alerts to shredders that want to be notified" do
      stub_twilio_confirmation
      @shredder2 = FactoryGirl.create(:shredder, :area => @area, :inches => 10, :email => 'jah@brah.com', :mobile => '4513501234')
      @shredder2.mobile_confirm
      stub_twitter
      @snow_report = FactoryGirl.build(:snow_report, :area => @area, :report_time => Time.now.to_date.ago(2.days), :snowfall_twelve => 2)
      expect {
        @snow_report.save
      }.to change(@snow_report.alerts, :size).by(1)
    end
    xit "should update twitter status when new snow falls" do
      Twitter.should_receive(:update).with(".@#{@area.twitter} is reporting 2\" of new snow!").and_return(true)
      @snow_report = FactoryGirl.build(:snow_report, :area => @area, :report_time => Time.now.to_date, :snowfall_twelve => 2)
      @snow_report.save
    end
    it "should send an alert for shredders when threshold is reached" do
      stub_twitter
      @snow_report = FactoryGirl.build(:snow_report, :area => @area, :report_time => Time.now.to_date, :snowfall_twelve => 2)
      expect {
        @snow_report.save
      }.to change(@snow_report.alerts, :size).by(1)
      @snow_report2 = FactoryGirl.build(:snow_report, :area => @area, :report_time => Time.now + 2.minutes, :snowfall_twelve => 5)
      expect {
        @snow_report2.save
      }.to change(@snow_report2.alerts, :size).by(0)
      @snow_report3 = FactoryGirl.build(:snow_report, :area => @area, :report_time => Time.now + 2.minutes, :snowfall_twelve => 8)
      expect {
        @snow_report3.save
      }.to change(@snow_report3.alerts, :size).by(1)
      @snow_report4 = FactoryGirl.build(:snow_report, :area => @area, :report_time => Time.now + 20.minutes, :snowfall_twelve => 8)
      expect {
        @snow_report4.save
      }.to change(@snow_report4.alerts, :size).by(0)
    end
    
    context "numbers" do
      it "should set a nil number_id when area has no numbers" do
        stub_twitter
        @snow_report = FactoryGirl.build(:snow_report, :area => @area, :report_time => Time.now.to_date.ago(2.days), :snowfall_twelve => 2)
        @snow_report.save
        @alert = @snow_report.alerts.first
        @alert.number.should be_nil
      end

      it 'should set a number if the area has a number' do
        stub_twitter
        @number = @area.numbers.create(:inbound => '+15558675309')
        @snow_report = FactoryGirl.build(:snow_report, :area => @area, :report_time => Time.now.to_date.ago(2.days), :snowfall_twelve => 2)
        @snow_report.save
        @alert = @snow_report.alerts.first
        @alert.number.should eql(@number)
      end

      it 'should cycle through the numbers when multiple numbers are available' do
        stub_twitter
        stub_twilio_confirmation
        @shredder3 = FactoryGirl.create(:shredder, :area => @area, :inches => 7, :email => 'jaaah@brah.com', :mobile => '4513501239')
        @shredder3.mobile_confirm
        @number1 = @area.numbers.create(:inbound => '+15558675309')
        @number2 = @area.numbers.create(:inbound => '+15558675308')
        @snow_report = FactoryGirl.build(:snow_report, :area => @area, :report_time => Time.now.to_date.ago(2.days), :snowfall_twelve => 8)
        @snow_report.save
        @snow_report.alerts.collect{|i| i.number }.should eql([@number1,@number2,@number1])
      end
    end
  end
end
