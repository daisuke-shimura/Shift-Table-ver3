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
      sheet.column_widths 14, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 12
      sheet.merge_cells("C2:D2")
      sheet.merge_cells("E2:F2")
      sheet.merge_cells("G2:H2")
      sheet.merge_cells("I2:J2")
      sheet.merge_cells("K2:L2")
      sheet.merge_cells("M2:N2")
      sheet.merge_cells("O2:P2")
      sheet.merge_cells("Q2:R2")
      sheet.merge_cells("S2:T2")
      sheet.merge_cells("U2:V2")
      sheet.merge_cells("W2:X2")
      sheet.merge_cells("Y2:Z2")
      sheet.merge_cells("AA2:AB2")
      sheet.add_row ["#{Time.current.to_date.month}月#{Time.current.to_date.day}日（水）"]
      User.all.each do |user|
        sheet.add_row [user.name]
      end
    end

    send_data package.to_stream.read, type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", filename: "users.xlsx"
  end

  private
  def user_params
    params.require(:user).permit(:name)
  end
end
