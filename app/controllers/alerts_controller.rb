class AlertsController < ApplicationController
  def answer
    @alert = Alert.find(params[:id])
    verb = Twilio::Verb.new { |v|
      if @alert
      v.play 'http://conepatrol.com/kids.mp3'
      v.pause '2'
      v.say "Yo bro, this is the cone patrol powder alert robot.  Bachelor is reporting #{@alert.snow_report.snowfall_twelve} inches of snow overnight.  It is currently #{@alert.snow_report.base_temp} degrees at the base. Go shred buddy!", :voice => 'woman'
      end
      v.hangup
    }
    render :xml => verb.response
  end
end
