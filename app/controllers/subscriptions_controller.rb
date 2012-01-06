class SubscriptionsController < ApplicationController
  before_filter :authenticate_shredder!

  def index 
    @shredder = current_shredder 
  end

  def edit
    @subscription = Subscription.find(params[:id])
    not_found unless @subscription && @subscription.shredder_id == current_shredder.id
  end

  def new
    @subscription = TextSubscription.new
  end

  def show

  end

  def create
    @subscription = current_shredder.text_subscriptions.new(params[:subscription])
    if @subscription.save
      redirect_to subscriptions_url
    else
      flash[:error] = "Please correct the errors and try again"
      render :action => :new
    end
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
