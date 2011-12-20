require 'spec_helper'

describe Shredder do
  before do
    Twilio::Sms.should_receive(:message).and_return(true)
    @shredder = Factory.create(:shredder)
  end
  it{ should validate_presence_of(:mobile) }
  it{ should validate_presence_of(:area_id) }
  it{ should validate_presence_of(:inches) }
  it{ should validate_numericality_of(:inches) }
  it{ should validate_uniqueness_of(:mobile).scoped_to(:area_id) }
  it{ should belong_to(:area) }
  it{ should have_many(:alerts) }
  it{ should have_many(:subscriptions) }
  it{ should have_many(:text_subscriptions) }

  it "should auto-create a confirmation_code" do
    @shredder.confirmation_code.empty?.should be_false
  end

  it "should send a confirmation code via twilio" do
    Twilio::Sms.should_receive(:message).exactly(1).times.and_return(true)
    @shredder = Factory.create(:shredder, :mobile => '1234567890',:email => 'meh@bleh.com')
  end

  it "should respond to confirm" do
    @shredder.should respond_to(:confirm)
  end

  it "should respond to active" do
    @shredder.should respond_to(:active)
  end

  it "should be inactive by default" do
    @shredder.active.should be_false
  end

  context 'confirm' do
    it "should auto-create a subscription on confirm" do
      expect{ @shredder.confirm }.should change(@shredder.text_subscriptions, :length).from(0).to(1)
    end
  end
end
