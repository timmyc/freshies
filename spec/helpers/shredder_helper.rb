module ShredderHelper
  def stub_twitter
    #Twitter.should_receive(:update).at_least(1).times.and_return(true)
  end
  def stub_twilio_confirmation
    @area ||= FactoryGirl.create(:area)
    @twilio_client = mock(Twilio::REST::Client)
    @twilio_account = mock(Twilio::REST::Account)
    @twilio_accounts = mock(Twilio::REST::Accounts)
    @twilio_messages = mock(Twilio::REST::Messages)
    Twilio::REST::Client.should_receive(:new).and_return(@twilio_client)
    @twilio_client.should_receive(:accounts).and_return(@twilio_accounts)
    @twilio_accounts.should_receive(:get).with(@area.twilio_account).and_return(@twilio_account)
    @twilio_messages.should_receive(:create).and_return(true)
    @twilio_account.stub_chain(:sms, :messages).and_return(@twilio_messages)
  end
  
  def stub_twilio_sms(options)
    @twilio_client = mock(Twilio::REST::Client)
    @twilio_account = mock(Twilio::REST::Account)
    @twilio_accounts = mock(Twilio::REST::Accounts)
    @twilio_messages = mock(Twilio::REST::Messages)
    Twilio::REST::Client.should_receive(:new).and_return(@twilio_client)
    @twilio_client.should_receive(:accounts).and_return(@twilio_accounts)
    @twilio_accounts.should_receive(:get).with(@area.twilio_account).and_return(@twilio_account)
    @twilio_messages.should_receive(:create).with(:from => options[:from], :to => options[:to], :body => options[:body]).and_return(true)
    @twilio_account.stub_chain(:sms, :messages).and_return(@twilio_messages)
  end
end

