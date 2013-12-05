class Api::PassesController < ApplicationController
  before_filter :set_area

  def real_time
    if @area
      count = 0
      Pass.where(real_time: true).all.each do |pass|
        next unless pass.shredder.area_id == @area.id
        today = Time.now.to_date
        today_turns = pass.skied_on?(today)
        if today_turns
          runs = pass.get_date_data(today)
          last_run_time = runs.empty? ? nil : runs.last.datetime
          pass.send_last_run(runs.last,@area)
        end
      end
      render :json => { alerts: count }
    else
      render :text => "unauthorized", :status => :unauthorized
    end
  end

  def end_of_day
    if @area
      count = 0
      Pass.include(:shredder).all.each do |pass|
        next unless pass.shredder.area_id == @area.id
        today_turns = pass.skied_on?(Time.now.to_date)
        if today_turns
          pass.send_day_stats(today_turns,@area)
          count += 1
        end
      end
      render :json => { alerts: count }
    else
      render :text => "unauthorized", :status => :unauthorized
    end
  end

  private

  def set_area
    @area = Area.find_by_key(params[:id])
  end

end
