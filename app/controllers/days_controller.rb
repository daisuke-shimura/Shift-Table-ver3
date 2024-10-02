class DaysController < ApplicationController
  def index
    date1 = Date.today
    @date1 = (date1 + (8-date1.wday))+14
    @date = Date.today
  end

  def index2
  end

  def show
  end

  def create
    day = Day.new(day_params)
    day.save
    redirect_to request.referer
  end

  def destroy
    Day.find(params[:id]).destroy
    redirect_to days_path
  end

  private
  def day_params
    params.require(:day).permit(:start, :finish)
  end
end
