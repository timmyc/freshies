class SubscriptionsController < ApplicationController
  before_filter :authenticate_shredder!

  def index 
    @shredder = current_shredder 
  end

  def edit
    @subscription = Subscription.find(params[:id])
    not_found unless @subscription && @subscription.shredder_id == current_shredder.id
  end

  def update
    @subscription = Subscription.find(params[:id])
    not_found unless @subscription && @subscription.shredder_id == current_shredder.id
    @subscription.update_attributes(params[:subscription])
    flash[:notice] = "Updated your subscription #{current_shredder.random_name}!"
    redirect_to subscriptions_url
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    not_found unless @subscription && @subscription.shredder_id == current_shredder.id
    @subscription.destroy
    flash[:notice] = "Deleted your subscription #{current_shredder.random_name}! :( :( :("
    redirect_to subscriptions_url
  end

end
