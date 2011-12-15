require 'spec_helper'

describe Area do
  it{ should validate_presence_of(:name) }
  it{ should validate_presence_of(:twitter) }
  it{ should validate_presence_of(:klass) }
  it{ should have_many(:snow_reports) }
  it{ should have_many(:shredders) }
  it{ should have_many(:alerts) }

  describe 'secret' do
    before do
      @area = Factory.create(:area)
    end

    it "should auto generate" do
      @area.secret.empty?.should be_false
    end

    it "should be 18 chars long" do
      @area.secret.length.should eql(18)
    end
  end

  describe 'key' do
    before do
      @area = Factory.create(:area)
    end
    
    it "should auto generate" do
      @area.key.empty?.should be_false
    end

    it "should be 6 chars long" do
      @area.key.length.should eql(6)
    end
  end

end
