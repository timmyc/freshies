class ShreddersController < ApplicationController

  def home 
    @shredder = Shredder.new
  end

  def confirm
    @shredder = current_shredder
  end

  def do_confirm
    @shredder = Shredder.find_by_mobile_and_confirmation_code(params[:shredder][:mobile],params[:shredder][:confirmation_code])
    if @shredder
      @shredder.confirm
    else
      flash[:error] = "Awww Snap!  We couldn't find your mobile bro!  Try again."
      @shredder = Shredder.new
      render :action => 'confirm'
    end
  end

end
