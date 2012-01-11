class ShreddersController < ApplicationController
  before_filter :authenticate_shredder!, :except => :home

  def home 
    @shredder = Shredder.new
    @areas = Area.find(:all, :include => [:snow_reports], :order => 'name asc')
  end

  def confirm
    @shredder = current_shredder
    if @shredder.confirmed?
      redirect_to subscriptions_url
    else
      @shredder.send_confirmation if params[:resend]
    end
  end

  def do_confirm
    @shredder = Shredder.find_by_mobile_and_confirmation_code(params[:shredder][:mobile],params[:shredder][:confirmation_code])
    if @shredder
      @shredder.mobile_confirm
    else
      flash[:error] = "Awww Snap!  We couldn't find your mobile bro!  Try again."
      @shredder = Shredder.new
      render :action => 'confirm'
    end
  end

end
