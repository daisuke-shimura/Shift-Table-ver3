class WedsController < ApplicationController
  def create
    day = Day.find(params[:day_id])
    Wed.new(day_id: day.id).save
    redirect_to request.referer
  end

  def destroy
    day = Day.find(params[:day_id])
    Wed.find_by(day_id: day.id).destroy
    redirect_to request.referer
  end
end
