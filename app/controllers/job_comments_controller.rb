class JobCommentsController < ApplicationController

  def create
    job = Job.find(params[:job_id])
    comment = JobComment.new(job_comment_params)
    comment.user_id = current_user.id
    comment.job_id = job.id
    comment.save
    redirect_to jobs_path
  end

  def destroy
    comment = JobComment.find(params[:id])
    comment.destroy
    redirect_to request.referer
  end


  private
  def job_comment_params
    params.require(:job_comment).permit(:comment)
  end

end
