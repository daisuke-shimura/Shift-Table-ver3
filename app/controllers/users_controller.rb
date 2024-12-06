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

      center_style = workbook.styles.add_style(alignment: { horizontal: :center }, border: { style: :thin, color: '000000', edges: [:bottom] })
      #blue_style = workbook.styles.add_style(bg_color: "4BACC6")
      border_style = workbook.styles.add_style(border: { style: :medium, color: '000000', edges: [:right] })
      thin_border_style = workbook.styles.add_style(alignment: { horizontal: :center }, border: { style: :thin, color: '000000', edges: [:right, :bottom] })
      thick_border_style = workbook.styles.add_style(alignment: { horizontal: :center }, border: { style: :medium, color: '000000', edges: [:bottom] })

      name_style = workbook.styles.add_style(
        alignment: { horizontal: :center },
        border: [{ style: :thin, color: '000000', edges: [:right, :bottom] },
                 { style: :medium, color: "000000", edges: [:left] }]
      )
      head_style = workbook.styles.add_style(
        alignment: { horizontal: :center },
        border: [{ style: :thin, color: '000000', edges: [:left, :bottom] },
                 { style: :medium, color: "000000", edges: [:right] }]
      )

      empty_row = Array.new(29, "")
      2.times {sheet.add_row(empty_row, style: thick_border_style)}
      11.times {sheet.add_row(empty_row, style: center_style)}
      sheet.add_row(empty_row, style: thick_border_style)

      merge_ranges = [
        "C2:D2", "E2:F2", "G2:H2", "I2:J2", "K2:L2",
        "M2:N2", "O2:P2", "Q2:R2", "S2:T2", "U2:V2",
        "W2:X2", "Y2:Z2", "AA2:AB2"
      ]
      merge_ranges.each { |range| sheet.merge_cells(range) }

      #sheet.rows[1].value = ["#{Time.current.to_date.month}月#{Time.current.to_date.day}日（水）","","10","","11","","12","","13","","14","","15","","16","","17","","18","","19","","20","","21","","22","",""]
      head = ["#{Time.current.to_date.month}月#{Time.current.to_date.day}日（水）", "", 10, "", 11, "", 12, "", 13, "", 14, "", 15, "", 16, "", 17, "", 18, "", 19, "", 20, "", 21, "", 22, ""]
      head.each_with_index do |value, i|
        sheet.rows[1].cells[i].value = value
      end
      #sheet.rows[1].cells[0].style = name_style
      #sheet.rows[1].cells[28].style = head_style

      int_ranges = [2,4,6,8,10,12,14,16,18,20,22,24,26]
      int_ranges.each { |int| sheet.rows[1].cells[int].type = :integer }


      #人の名前
      User.all.each_with_index do |user,i|
        sheet.rows[(i+2)].cells[0].value = user.name
        sheet.rows[(i+2)].cells[0].style = name_style
      end
      
      #縦の太線
      #thick_border_ranges = [0,2,4,6,8,10,12,14,16,18,20,22,24,26]
      #thin_border_ranges = [1,3,5,7,9,11,13,15,17,19,21,23,25,27]
      #border_ranges.each { |range| sheet.col_style(range, border_style)}

      index_box =     [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28]
      shift_box = [[2,[1,2,3,4,5,6,7,8,9,10,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0]],
                   [3,[1,2,3,4,5,6,0,0,0,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0]],
                   [4,[0,0,0,0,0,0,0,0,0,10,11,12,13,14,15,16,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0]]]
      shift_box.each do |i,k|
        k.each_with_index do |j,x|
          if j > 0
            sheet.rows[i].cells[x+1].style = blue_style(x+1,workbook)
          else
            sheet.rows[i].cells[x+1].style = white_style(x+1,workbook)
          end
        end
      end

      #青に塗りつぶし
      #shift_box = [[2,[1,2,3,4,5,6,7,8,9,10]],[3,[1,2,3,4,5,6]],[4,[10,11,12,13,14,15,16]]]
      #shift_box.each do |i,k|
        #k.each do |j|
          #sheet.rows[i].cells[j].style = blue_style(j,workbook)
        #end
      #end
      sheet.rows[6].cells[2].style = blue_style(2,workbook)
      sheet.rows[5].cells[3].style = blue_style(3,workbook)

      #sheet.rows[5].cells[3].value = 3
      #sheet.rows[5].cells[3].type = :integer

      #列の幅指定（最後）
      sheet.column_widths 14, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 12
    end

    send_data package.to_stream.read, type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", filename: "users.xlsx"

  end

  private
  def user_params
    params.require(:user).permit(:name)
  end

  def blue_style(x,workbook)
    n2_border = workbook.styles.add_style(
    alignment: { horizontal: :center },
    bg_color: "4BACC6", 
    border: [{ style: :medium, color: "000000", edges: [:right] },
             { style: :thin, color: "000000", edges: [:bottom] }]
    )
    n1_border = workbook.styles.add_style(
      alignment: { horizontal: :center },
      bg_color: "4BACC6",
      border: { style: :thin, color: "000000", edges: [:right, :bottom] }
    )
    if x % 2 == 0
      n2_border
    else
      n1_border
    end
  end

  def white_style(x,workbook)
    n2_border = workbook.styles.add_style(
      alignment: { horizontal: :center },
      border: [{ style: :medium, color: "000000", edges: [:right] },
               { style: :thin, color: "000000", edges: [:bottom] }]
    )
    n1_border = workbook.styles.add_style(
      alignment: { horizontal: :center },
      border: { style: :thin, color: "000000", edges: [:right, :bottom] }
    )
    if x % 2 == 0
      n2_border
    else
      n1_border
    end
  end

end
