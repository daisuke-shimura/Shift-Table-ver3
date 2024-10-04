class MonsController < ApplicationController
  def create
    day = Day.find(params[:day_id])
    Mon.new(day_id: day.id).save
    redirect_to request.referer
  end

  def destroy
    day = Day.find(params[:day_id])
    Mon.find_by(day_id: day.id).destroy
    redirect_to request.referer
  end
end
