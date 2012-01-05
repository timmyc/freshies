require 'spec_helper'

describe TextSubscription do
  it{ should belong_to(:area) }
  it{ should belong_to(:shredder) }
  it{ should have_many(:alerts) }
  
  before do
    @shredder = Factory.create(:shredder)
    @shredder.mobile_confirm
    @text_subscription = @shredder.text_subscriptions.first
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
end
