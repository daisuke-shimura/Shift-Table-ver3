class UsersController < ApplicationController

  def index
    @user = User.all
    @job_comment = JobComment.new
  end

  def edit
  end

  def show
    @user = User.find(params[:id])
    @job = @user.jobs
  end
end
