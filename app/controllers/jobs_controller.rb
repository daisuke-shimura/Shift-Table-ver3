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
    @shifts = Job.all
    #@shift = Job.find(params[:id])
  end

  def show
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    job = Job.find(params[:id])
    job.update(job_params)
    redirect_to jobs_path
  end

  def destroy
    job = Job.find(params[:id])
    job.destroy
    redirect_to jobs_path
  end


  private
  def job_params
    params.require(:job).permit(:time)
  end

end
