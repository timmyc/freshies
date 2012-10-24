require 'spec_helper'

describe Api::SmsController do

  describe "GET" do
    before do
      @from = '+15413503333'
      @area = FactoryGirl.create(:area)
      @number = @area.numbers.create(:inbound => '+15558675309')
    end
    
    it "should create a new shredder" do
      lambda{
        get 'index', :To => @number.inbound, :From => @from, :Body => '4 in'
      }.should change(Shredder,:count).by(1)
    end

    context 'stop' do
      before do
        get 'index', :To => @number.inbound, :From => @from, :Body => '4 in'
      end

      it "should delete shredder" do
        lambda{
          get 'index', :To => @number.inbound, :From => @from, :Body => 'STOP'
        }.should change(Shredder,:count).by(-1)
      end

      it "should delete shredder and TextSubscription" do
        lambda{
          get 'index', :To => @number.inbound, :From => @from, :Body => 'STOP'
        }.should change(TextSubscription,:count).by(-1)
      end
      
      it "should serve up the correct twiml" do
        get 'index', :To => @number.inbound, :From => @from, :Body => 'STOP'
        response.should be_success
        xml = ActiveResource::Formats::XmlFormat.decode(response.body)
        xml['Sms'].should eql("All alerts for #{@number.area.name} have been deleted. :( ")
      end
    end

    it "should serve up proper twiml" do
      get 'index', :To => @number.inbound, :From => @from, :Body => '4 in'
      response.should be_success
      xml = ActiveResource::Formats::XmlFormat.decode(response.body)
      xml['Sms'].should eql("#{@number.area.name} powder alert set for 4\"!")
    end

    it "should change inches" do
      @shredder = Shredder.find_or_create_by_number_area(:area_id => @area.id, :mobile => @from, :inches => '4')
      @sub = @shredder.text_subscriptions.first
      get 'index', :To => @number.inbound, :From => @from, :Body => '8'
      @sub2 = TextSubscription.find(@sub)
      @sub2.inches.should eql(8)
    end
    
  end

end


