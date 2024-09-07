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
    @job = Job.new
    @shifts = Job.all
    @job_comment = JobComment.new
    @comment = JobComment.all
    #Job.order(user_id)
  end

  def show
    @job = Job.find(params[:id])
    @job_comment = JobComment.new
    @comment = JobComment.all
  end

  def edit
    @job = Job.find(params[:id])
    @user = User.all
  end

  def update
    job = Job.find(params[:id])
    job.update(job_params)
    redirect_to users_path
  end

  def destroy
    job = Job.find(params[:id])
    job.destroy
    redirect_to request.referer
  end


  private
  def job_params
    params.require(:job).permit(:time1,:time2,:time3,:time4,:time5,:time6,:time7)
  end

end
