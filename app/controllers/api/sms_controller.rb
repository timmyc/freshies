class Api::SmsController < ApplicationController
  before_filter :set_area

  def index
    if @number
      if params[:Body] =~ /forecast [0-9]/i
        matches = params[:Body].match(/forecast (\d,*)/i)
        inches = matches[1]
        @shredder = Shredder.find_or_create_by_number_area(:area_id => @number.area_id, :mobile => params[:From], :inches => inches)
        @noaa_subscription = NoaaSubscription.find_or_create_by_shredder_id_and_area_id(@shredder.id,@number.area_id)
        @noaa_subscription.update_attributes(:active => true, :inches => matches[1], :message => 'NOAA is forecasting {{snowfall_min}}" to {{snowfall_max}}" over the next 24 hours at {{area}}')
        resp = Twilio::TwiML::Response.new do |v|
          v.Sms "#{@number.area.name} forecast alert set for #{inches}\"!"
        end
      elsif params[:Body].strip.to_i > 0
        inches = params[:Body].strip.to_i
        @shredder = Shredder.find_or_create_by_number_area(:area_id => @number.area_id, :mobile => params[:From], :inches => inches)
        @text_subscription = @shredder.text_subscriptions.first
        @text_subscription.update_attribute('inches',inches)
        resp = Twilio::TwiML::Response.new do |v|
          v.Sms "#{@number.area.name} powder alert set for #{inches}\"!"
        end
      elsif params[:Body].downcase.strip == 'stop'
        @shredder = Shredder.find_by_area_id_and_mobile(@number.area_id,params[:From])
        @shredder.destroy
        resp = Twilio::TwiML::Response.new do |v|
          v.Sms "All alerts for #{@number.area.name} have been deleted. :( "
        end
      else
        resp = Twilio::TwiML::Response.new do |v|
          v.Sms "Please reply with number of inches to signup for #{@number.area.name} Powder Alerts"
        end
      end
    else
      #number not found
      resp = Twilio::TwiML::Response.new do |v|
        v.Sms "unsupported number http://getfreshi.es"
      end
    end
    render :xml => resp.text
  end

  private

  def set_area
    @number = Number.find_by_inbound(params[:To])
  end

end

