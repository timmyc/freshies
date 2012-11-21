require 'spec_helper'

describe IosSubscription do
  include ShredderHelper
  it{ should belong_to(:area) }
  it{ should belong_to(:shredder) }
  it{ should have_many(:alerts) }
  it{ should validate_presence_of(:message) }
  
  before do
    stub_twilio_confirmation
    @shredder = FactoryGirl.create(:shredder)
    @shredder.mobile_confirm
    @ios_subscription = @shredder.ios_subscriptions.create(:active => true, :inches => 4, :message => 'omg it snowed {{snowfall_twelve}} and it is {{base_temp}} at the base!')
  end

  it "should respond to message_length" do
    @ios_subscription.should respond_to(:message_length)
  end

  it "should have the correct message_length" do
    @ios_subscription.message_length.should eql(2000)
  end

  it "should have a description" do
    @ios_subscription.should respond_to(:description)
  end

  context 'update from app' do
    it{ should respond_to(:update_from_app) }
    it 'should update active to false when false' do
      lambda{
        @ios_subscription.update_from_app(:inches => 4, :active => 'false')
      }.should change(@ios_subscription,:active).from(true).to(false)
    end
    it 'should update inches to 2' do
      lambda{
        @ios_subscription.update_from_app(:inches => 2, :active => 'true')
      }.should change(@ios_subscription,:inches).from(4).to(2)
    end
  end

end
