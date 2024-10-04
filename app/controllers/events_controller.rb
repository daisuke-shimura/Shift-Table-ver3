class EventsController < ApplicationController
  def new
    @event = Event.new
    @day = Day.find(params[:day_id])
    @user = User.all
    @job_comment = JobComment.all
  end

  def create
    day = Day.find(params[:day_id])
    Event.new(day_id: day.id).save
    redirect_to new_day_job_path(day.id)
  end

  def destroy
  end

  private
  def event_params
    params.require(:event).permit(:time1,:time2,:time3,:time4,:time5,:time6,:time7)
  end

end
