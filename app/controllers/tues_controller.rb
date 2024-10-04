class TuesController < ApplicationController
  def create
    day = Day.find(params[:day_id])
    Tue.new(day_id: day.id).save
    redirect_to request.referer
  end

  def destroy
    day = Day.find(params[:day_id])
    Tue.find_by(day_id: day.id).destroy
    redirect_to request.referer
  end
end
