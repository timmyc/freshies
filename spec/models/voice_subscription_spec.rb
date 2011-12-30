require 'spec_helper'

describe VoiceSubscription do
  it{ should belong_to(:area) }
  it{ should belong_to(:shredder) }
  it{ should have_many(:alerts) }
  it{ should validate_presence_of(:message) }

  it "should have an array of acceptable intros" do
    VoiceSubscription.intros.should be_an_instance_of(Array)
  end
  
  before do
    @shredder = Factory.create(:shredder)
    @shredder.mobile_confirm
    @voice_subscription = @shredder.voice_subscriptions.create(:inches => 4, :message => 'omg it snowed {{snowfall_twelve}} and it is {{base_temp}} at the base!')
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
