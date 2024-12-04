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
    flash[:blue_message] = "変更しました。"
    redirect_to user_path(user.id)
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path
  end

#table作成
  def export
    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "User_index") do |sheet|
      sheet.add_row ["ID", "名前"]
      User.all.each do |user|
        sheet.add_row [user.id, user.name]
      end
    end

    send_data package.to_stream.read, type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", filename: "users.xlsx"
  end

  private
  def user_params
    params.require(:user).permit(:name)
  end
end
