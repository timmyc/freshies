class AlertsController < ApplicationController

  def answer
    @alert = Alert.find(params[:id])
    verb = Twilio::Verb.new { |v|
      if @alert
        @subscription = @alert.subscription
        v.play "http://conepatrol.com/clips/#{@subscription.intro}.mp3" if @subscription.intro
        v.pause '2'
        v.say Mustache.render(@alert.subscription.message, @alert.snow_report.alert_attributes), :voice => @subscription.gender
      end
      v.hangup
    }
    render :xml => verb.response
  end

end
