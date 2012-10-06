require 'spec_helper'

describe Alert do
  it{ should belong_to(:snow_report) }
  it{ should belong_to(:shredder) }
  it{ should belong_to(:area) }
  it{ should belong_to(:subscription) }

  it "should call send_message after_create" do
    @alert = FactoryGirl.build(:alert)
    @alert.should_receive(:deliver)
    @alert.save
  end

  context 'date sent' do
    before do
      @alert = FactoryGirl.build(:alert)
    end

    it "should have the column" do
      @alert.should respond_to(:date_sent)
    end

    it "should populate the value on create" do
      @alert.save
      @alert.date_sent.should eql(Time.now.to_date)
    end

    it "should return the proper records for for_subscription_date" do
      Alert.for_subscription_date(Time.now.to_date,@alert.subscription_id).size.should eql(0)
      @alert.save
      Alert.for_subscription_date(Time.now.to_date,@alert.subscription_id).size.should eql(1)
    end

  end

  context 'alert types' do
    before do
      @area = FactoryGirl.create(:area)
      @shredder = FactoryGirl.create(:shredder, :area => @area)
      @shredder.mobile_confirm
      @snow_report = FactoryGirl.build(:snow_report, :area => @area, :report_time => Time.now)
    end
    
    context 'TextSubscriptions' do
      it "should create an alert for a text subscription" do
        expect{ @snow_report.save }.to change(Alert, :count).by(1)
      end

      it "should create the correct type of alert" do
        @snow_report.save
        @alert = @shredder.alerts.last
        @alert.subscription.should be_an_instance_of(TextSubscription)
      end

      it "should call twilio for TextSubscription" do
        Twilio::Sms.should_receive(:message).exactly(1).times.and_return(true)
        @snow_report.save
        @alert = Alert.last
        @alert.send_message
      end

      it "should not send an alert twice" do
        @snow_report.save
        @alert = Alert.last
        @alert.send_message
        Twilio::Sms.should_not_receive(:message)
        @alert.send_message
      end
    end
  end
end
