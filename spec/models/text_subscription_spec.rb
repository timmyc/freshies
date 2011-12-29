require 'spec_helper'

describe TextSubscription do
  it{ should belong_to(:area) }
  it{ should belong_to(:shredder) }
  it{ should have_many(:alerts) }
  
  it "should have a description" do
    @shredder = Factory.create(:shredder)
    @shredder.mobile_confirm
    @text_subscription = @shredder.text_subscriptions.first
    @text_subscription.should respond_to(:description)
  end
end
