class Api::SmsController < ApplicationController
  before_filter :set_area

  def index
    if @number
      if params[:Body].strip.to_i > 0
        inches = params[:Body].strip.to_i
        @shredder = Shredder.find_or_create_by_number_area(:area_id => @number.area_id, :mobile => params[:From], :inches => inches)
        @text_subscription = @shredder.text_subscriptions.first
        @text_subscription.update_attribute('inches',inches)
        resp = Twilio::TwiML::Response.new do |v|
          v.Sms "#{@number.area.name} powder alert set for #{inches}\"!"
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

