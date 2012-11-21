class Api::IosController < ApplicationController
  
  def index
    @shredder = Shredder.find_or_create_from_android(params)
    render :json => {:success => true}
  end

  def create
    params[:push_token] = params[:gcm_id]
    @shredder = Shredder.find_or_create_from_android(params)
    if @shredder.ios_subscriptions.empty?
      @shredder.ios_subscriptions.create(:inches => params[:inches], :area_id => @shredder.area_id, :active => true, :message => '{{area}} has {{new_snow}} inches of new snow!')
    else
      @shredder.ios_subscriptions.first.update_from_app(params)
    end
    render :json => {:success => true}
  end

end

