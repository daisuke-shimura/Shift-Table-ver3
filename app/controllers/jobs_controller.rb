class JobsController < ApplicationController

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    @job.user_id = current_user.id
    @job.save
    redirect_to jobs_path
  end

  def index
  end

  def show
  end

  def edit
  end


  private
  def job_params
    params.require(:job).permit(:time)
  end

end
