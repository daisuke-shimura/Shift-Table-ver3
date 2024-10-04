class SatsController < ApplicationController
  def create
    day = Day.find(params[:day_id])
    Sat.new(day_id: day.id).save
    redirect_to request.referer
  end

  def destroy
    day = Day.find(params[:day_id])
    Sat.find_by(day_id: day.id).destroy
    redirect_to request.referer
  end
end
