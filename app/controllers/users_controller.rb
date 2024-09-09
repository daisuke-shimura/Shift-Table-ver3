class UsersController < ApplicationController

  def index
    @user = User.all
    @job_comment = JobComment.all
  end

  def edit
  end

  def show
    @user = User.find(params[:id])
    @job = @user.jobs
  end
end
