require 'spec_helper'

describe Alert do
  it{ should belong_to(:snow_report) }
  it{ should belong_to(:shredder) }
  it{ should belong_to(:area) }

  it "should call send_message after_create" do
    @alert = Factory.build(:alert)
    @alert.should_receive(:deliver)
    @alert.save
  end
end
