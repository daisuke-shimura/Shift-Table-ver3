class EventsController < ApplicationController
  def new
    @event = Event.new
    @day = Day.find(params[:day_id])
    @user = User.all
    @job_comment = JobComment.where(day_id: @day.id)
  end

  def create
    day = Day.find(params[:day_id])
    event = Event.new(event_params)
    event.day_id = day.id
    event.save
    redirect_to new_day_job_path(day.id)
  end

  def destroy
    day = Day.find(params[:day_id])
    Event.find_by(day_id: day.id).destroy
    redirect_to new_day_job_path(day.id)
  end

  def edit
    day = Day.find(params[:day_id])
    @event = Event.find_by(day_id: day.id)
    @day = Day.find(params[:day_id])
    @user = User.all
    @job_comment = JobComment.where(day_id: @day.id)
  end

  def update
    day = Day.find(params[:day_id])
    evemt = Event.find_by(day_id: day.id)
    evemt.update(event_params)
    redirect_to new_day_job_path(day.id)
  end

  private
  def event_params
    params.require(:event).permit(:time1,:time2,:time3,:time4,:time5,:time6,:time7)
  end

end
