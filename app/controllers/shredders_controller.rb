class ShreddersController < ApplicationController

  def index
    @shredder = Shredder.new
  end

  def create
    @shredder = Shredder.find_or_create_by_area_id_and_mobile(params[:shredder][:area_id],params[:shredder][:mobile])
    @shredder.update_attributes(:inches => params[:shredder][:inches])
    render :action => 'confirm'
  end

  def confirm
    @shredder = Shredder.new
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
