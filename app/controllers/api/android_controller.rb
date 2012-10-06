class Api::AndroidController < ApplicationController

  def index
    @shredder = Shredder.find_or_create_from_android(params)
    @shredder.android_subscriptions.first.update_from_app(params)
    render :json => {:success => true}
  end

end

