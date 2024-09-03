class UsersController < ApplicationController
  def edit
  end

  def show
    @user = User.find(params[:id])
    @job = @user.jobs
  end
end
