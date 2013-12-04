class Api::PassesController < ApplicationController
  before_filter :set_area

  def end_of_day
    if @area
      Pass.include(:shredder).all.each do |pass|
        next unless pass.shredder.area_id == @area.id
        today_turns = pass.skied_on?(Time.now.to_date)
        if today_turns
          pass.send_day_stats(today_turns,@area)
        end
      end
      render :json => @forecast
    else
      render :text => "unauthorized", :status => :unauthorized
    end
  end

  private

  def set_area
    authenticate_or_request_with_http_basic do |user, password|
      @area = Area.find_by_key_and_secret(user,password)
    end
  end

end

