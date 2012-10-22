require 'spec_helper'

describe ShreddersController do
  include ShredderHelper
  describe "GET" do
    before do
      @area = FactoryGirl.create(:area)
      stub_twilio_confirmation
      @shredder = FactoryGirl.create(:shredder, :confirmed_at => Time.now, :area => @area)
    end
    
    it "should not allow access to confirm page unless logged in" do
      get 'confirm'
      response.should_not be_success
    end

    it "should send email confirmation instructions" do
      
    end

    it "should allow access to confirm page when logged in" do
      sign_in @shredder
      get 'confirm'
      response.should be_success
    end

    it "should confirm the account with the correct code" do
      sign_in @shredder
      post 'do_confirm', :shredder => { :mobile => @shredder.mobile, :confirmation_code => @shredder.confirmation_code }
      response.should render_template(:do_confirm)
    end
    
    it "should render the confirm form with incorrect code" do
      sign_in @shredder
      post 'do_confirm', :shredder => { :mobile => @shredder.mobile, :confirmation_code => 'ballz' }
      response.should render_template(:confirm)
    end
  end

end

