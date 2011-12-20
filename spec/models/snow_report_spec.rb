require 'spec_helper'

describe SnowReport do
  it{ should belong_to(:area) }
  it{ should have_many(:alerts) }
  it{ should validate_presence_of(:report_time) }
  it{ should validate_presence_of(:area_id) }
  before do
    @area = Factory.create(:area)
    @shredder = Factory.create(:shredder, :area => @area)
    @shredder.confirm
    @snow_report = Factory.build(:snow_report, :area => @area, :report_time => Time.now)
  end

  context "scopes" do
    it "should provide today's reports" do
      @snow_report.save
      @snow_report2 = Factory.create(:snow_report, :area => @area, :report_time => Time.now.to_date.ago(2.days))
      SnowReport.for_date(Time.now.to_date).size.should eql(1)
    end
  end

  context "first_report" do
    it "should respond to first_report" do
      @snow_report.save
      @snow_report.respond_to?(:first_report).should be_true
    end
    it "should set first_report true if no other reports exist for this date" do
      @snow_report.save
      @snow_report.first_report.should be_true
    end
    it "should set first_report false if other reports exist for this date" do
      @snow_report.save
      @snow_report2 = Factory.create(:snow_report, :area => @area, :report_time => Time.now + 2.minutes)
      @snow_report2.first_report.should be_false
    end
    it "should not create alerts after create if first report if snowfall is 0" do
      @snow_report = Factory.build(:snow_report, :area => @area, :report_time => Time.now, :snowfall_twelve => 0)
      expect {
        @snow_report.save
      }.to change(@snow_report.alerts, :size).by(0)
    end
    it "should have the right set of shredders to notify" do
      @subscriptions = Subscription.for_inches_area(1,@area.id)
      @subscriptions.first.shredder_id.should eql(@shredder.id)
    end
    it "should be the first report" do
      @snow_report.save
      @snow_report.first_report.should be_true
    end
    it "should create alerts after create if first report if snowfall is >= 1" do
      @snow_report = Factory.build(:snow_report, :area => @area, :report_time => Time.now.to_date.ago(2.days), :snowfall_twelve => 2)
      expect {
        @snow_report.save
      }.to change(@snow_report.alerts, :size).by(1)
    end
    it "should only send alerts to shredders that want to be notified" do
      @shredder2 = Factory.create(:shredder, :area => @area, :inches => 10, :email => 'jah@brah.com', :mobile => '4513501234')
      @shredder2.confirm
      @snow_report = Factory.build(:snow_report, :area => @area, :report_time => Time.now.to_date.ago(2.days), :snowfall_twelve => 2)
      expect {
        @snow_report.save
      }.to change(@snow_report.alerts, :size).by(1)
    end
  end
end
