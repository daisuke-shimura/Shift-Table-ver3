class UsersController < ApplicationController

  def index
    @user = User.all
  end

  def edit
  end

  def show
    @user = User.find(params[:id])
    @job = @user.jobs
  end
end
