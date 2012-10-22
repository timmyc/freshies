class AlertsController < ApplicationController

  def answer
    @alert = Alert.find(params[:id])
    resp = Twilio::TwiML::Response.new do |v|
      if @alert
        @subscription = @alert.subscription
        v.Play "http://conepatrol.com/clips/#{@subscription.intro}.mp3" if @subscription.intro
        v.Pause '2'
        v.Say Mustache.render(@alert.subscription.message, @alert.snow_report.alert_attributes), :voice => @subscription.gender
      end
      v.Hangup
    end
    render :xml => resp.text
  end

end
