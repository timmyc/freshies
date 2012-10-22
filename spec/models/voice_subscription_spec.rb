require 'spec_helper'

describe VoiceSubscription do
  include ShredderHelper
  it{ should belong_to(:area) }
  it{ should belong_to(:shredder) }
  it{ should have_many(:alerts) }
  it{ should validate_presence_of(:message) }
  it{ should allow_value('male').for(:gender) }
  it{ should allow_value('female').for(:gender) }
  it{ should_not allow_value('shemale').for(:gender) }
  it{ should_not allow_value('dancing-queen').for(:intro) }
  it{ should_not allow_value('').for(:intro) }
  it{ should allow_value('kids').for(:intro) }
  it{ should allow_value(nil).for(:intro) }

  it "should have an array of acceptable intros" do
    VoiceSubscription.intros.should be_an_instance_of(Array)
  end
  
  before do
    stub_twilio_confirmation
    @shredder = FactoryGirl.create(:shredder)
    @shredder.mobile_confirm
    @voice_subscription = @shredder.voice_subscriptions.create(:inches => 4, :message => 'omg it snowed {{snowfall_twelve}} and it is {{base_temp}} at the base!')
  end

  it "should respond to message_length" do
    @voice_subscription.should respond_to(:message_length)
  end

  it "should have the correct message_length" do
    @voice_subscription.message_length.should eql(330)
  end

  it "should have a description" do
    @voice_subscription.should respond_to(:description)
  end

  it "should respond to intro" do
    @voice_subscription.should respond_to(:intro)
  end
  
  it "should respond to gender" do
    @voice_subscription.should respond_to(:gender)
  end
end
