class VoiceSubscriptionsController < ApplicationController
  before_filter :authenticate_shredder!

  def index 
    @shredder = current_shredder 
  end

  def new
    @voice_subscription = current_shredder.voice_subscriptions.new
  end

  def create
    params[:subscription][:intro] = params[:subscription][:intro].strip.empty? ? nil : params[:subscription][:intro]
    @voice_subscription = current_shredder.voice_subscriptions.create(params[:subscription])
    if !@voice_subscription.valid?
      flash[:error] = "Awww Snap!  Please fix dem errors!  Try again."
      render :action => :new
    else
      flash[:notice] = "Your subscription has been saved!"
      redirect_to subscriptions_url
    end
  end

  def edit
    @subscription = VoiceSubscription.find(params[:id])
    not_found unless @subscription && @subscription.shredder_id == current_shredder.id
  end

  def update
    @subscription = VoiceSubscription.find(params[:id])
    not_found unless @subscription && @subscription.shredder_id == current_shredder.id
    @subscription.update_attributes(params[:voice_subscription])
    flash[:notice] = "Updated your subscription #{current_shredder.random_name}!"
    redirect_to subscriptions_url
  end

  def destroy
    @subscription = VoiceSubscription.find(params[:id])
    not_found unless @subscription && @subscription.shredder_id == current_shredder.id
    @subscription.destroy
    flash[:notice] = "Deleted your subscription #{current_shredder.random_name}! :( :( :("
    redirect_to subscriptions_url
  end

end
