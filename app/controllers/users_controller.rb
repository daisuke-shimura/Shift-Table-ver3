class UsersController < ApplicationController

  def index
    @user = User.pluck(:id, :name)
  end

  def edit
  end

  def show
    today = Time.current.to_date + 2
    @day = Day.where("start > ?", today).pluck(:start, :finish, :id)
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to user_path(user.id)
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit(:name)
  end
end
