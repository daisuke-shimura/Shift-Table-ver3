class DaysController < ApplicationController
  def index
    @kyou = Time.current.to_date
    @date = (@kyou + (8-@kyou.wday))+14
    today = @kyou + 2
    @day = Day.where("start > ?", today)
    #新規日程自動作成機能
    unless Day.exists?(start: @date)
      flash.now[:green_message] = "自動作成"
      Day.create(start:  @date, finish: @date+6)
    end
  end

  def index2
    today = Time.current.to_date + 3
    @now = Day.where("start >= ? AND limityan = ?", today, true)
    @day = Day.where("start < ?", today).page(params[:page])
  end

  def show
    @day = Day.find(params[:id])
    @user = User.all
    @job_comment = JobComment.where(day_id: @day.id)
  end

  def create
    day = Day.new(day_params)
    if day.save
      redirect_to request.referer
    else
      flash[:red_message] = "Error：既につくられた日程です"
      redirect_to request.referer
    end
  end

  def destroy
    Day.find(params[:id]).destroy
    redirect_to days_path
  end

  def update
    day = Day.find(params[:id])
    if day.limityan == false
      day.update(limityan: true)
    else
      day.update(limityan: false)
    end
    redirect_to days_path
  end

  private
  def day_params
    params.require(:day).permit(:start, :finish)
  end
end
