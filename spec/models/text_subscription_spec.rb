require 'spec_helper'

describe TextSubscription do
  include ShredderHelper
  it{ should belong_to(:area) }
  it{ should belong_to(:shredder) }
  it{ should have_many(:alerts) }
  it{ should validate_uniqueness_of(:area_id).scoped_to(:shredder_id).with_message('is already being used in another one of your subscriptions') }
  
  before do
    stub_twilio_confirmation
    @shredder = FactoryGirl.create(:shredder)
    @shredder.mobile_confirm
    @text_subscription = @shredder.text_subscriptions.first
    @text_subscription.update_attribute('message','new snow: {{new_snow}}')
  end

  it "should have a description" do
    @text_subscription.should respond_to(:description)
  end

  it "should respond to message_length" do
    @text_subscription.should respond_to(:message_length)
  end

  it "should have the correct message_length" do
    @text_subscription.message_length.should eql(130)
  end

  context 'send_message' do
    it "should send the correct alert body" do
      @snow_report = FactoryGirl.create(:snow_report, :area => @shredder.area, :report_time => Time.now)
      @alert = Alert.last
      stub_twilio_sms({:from => Cone::Application.config.twilio_number, :to => @shredder.mobile, :body => 'new snow: 2'})
      @text_subscription.send_message(@alert)
    end
    
    it 'should use the number attatched to the alert to send the message' do
      @number = @shredder.area.numbers.create(:inbound => '+15558675309')
      @snow_report = FactoryGirl.create(:snow_report, :area => @shredder.area, :report_time => Time.now)
      @alert = Alert.last
      @alert.update_attribute('number_id', @number.id)
      stub_twilio_sms({:from => '+15558675309', :to => @shredder.mobile, :body => 'new snow: 2'})
      @text_subscription.send_message(@alert)
    end
  end
end
