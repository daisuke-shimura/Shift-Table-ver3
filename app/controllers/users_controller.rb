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
      sheet.merge_cells("C1:D1")
      sheet.merge_cells("E1:F1")
      sheet.merge_cells("G1:H1")
      sheet.merge_cells("I1:J1")
      sheet.merge_cells("K1:L1")
      sheet.merge_cells("M1:N1")
      sheet.merge_cells("O1:P1")
      sheet.merge_cells("Q1:R1")
      sheet.merge_cells("S1:T1")
      sheet.merge_cells("U1:V1")
      sheet.merge_cells("W1:X1")
      sheet.merge_cells("Y1:Z1")
      sheet.merge_cells("AA1:AB1")
      sheet.add_row ["#{Time.current.to_date.month}月#{Time.current.to_date.day}日（水）"]
      #data_style = workbook.styles.add_style(sz: 8)
      #sheet.add_row ["","","10","11","12","13","14","15","16","17","18","19","20","21","22"], style: data_style
      
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
