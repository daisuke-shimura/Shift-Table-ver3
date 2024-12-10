class ExcelController < ApplicationController
  #table作成
  def export
    day = Day.find(params[:day_id])
    user = User.all
    row = 0

    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Sheet1") do |sheet|

      center_style = workbook.styles.add_style(alignment: { horizontal: :center }, border: { style: :thin, color: '000000', edges: [:bottom] })
      #blue_style = workbook.styles.add_style(bg_color: "4BACC6")
      border_style = workbook.styles.add_style(border: { style: :medium, color: '000000', edges: [:right] })
      thin_border_style = workbook.styles.add_style(alignment: { horizontal: :center }, border: { style: :thin, color: '000000', edges: [:right, :bottom] })
      thick_border_style = workbook.styles.add_style(alignment: { horizontal: :center }, border: { style: :medium, color: '000000', edges: [:bottom] })
      thick_top_border_style = workbook.styles.add_style(alignment: { horizontal: :center }, border: { style: :medium, color: '000000', edges: [:bottom, :top] })

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

      empty_row = Array.new(30, " ")

#月曜日ここから
      2.times do
        sheet.add_row(empty_row, style: thick_border_style)
        row += 1
      end

      merge_ranges = [
        "C#{row}:D#{row}", "E#{row}:F#{row}", "G#{row}:H#{row}", "I#{row}:J#{row}", "K#{row}:L#{row}",
        "M#{row}:N#{row}", "O#{row}:P#{row}", "Q#{row}:R#{row}", "S#{row}:T#{row}", "U#{row}:V#{row}",
        "W#{row}:X#{row}", "Y#{row}:Z#{row}", "AA#{row}:AB#{row}"
      ]
      merge_ranges.each { |range| sheet.merge_cells(range) }

      head = ["#{day.start.month}月#{day.start.day}日（月）", "", 10, "", 11, "", 12, "", 13, "", 14, "", 15, "", 16, "", 17, "", 18, "", 19, "", 20, "", 21, "", 22, ""]
      head.each_with_index do |value, i|
        sheet.rows[1].cells[i].value = value
      end

      int_ranges = [2,4,6,8,10,12,14,16,18,20,22,24,26]
      int_ranges.each { |int| sheet.rows[1].cells[int].type = :integer }

         # y=2x-18      [0    ,1    ,2    ,3    ,4    ,5    ,6    ,7    ,8    ,9    ,10   ,11   ,12   ,13   ,14   ,15   ,16   ,17   ,18   ,19   ,20   ,21   ,22   ,23   ,24   ,25   ,26   ,27   ]
         #              [     ,     ,10   ,     ,11   ,     ,12   ,     ,13   ,     ,14   ,     ,15   ,     ,16   ,     ,17   ,     ,18   ,     ,19   ,     ,20   ,     ,21   ,     ,22   ,     ]
         #配列番号      0,  1  ,  2  ,  3  ,  4  ,  5  ,  6  ,  7  ,  8  ,  9  ,  10 ,  11 ,  12 ,  13 ,  14 ,  15 ,  16 ,  17 ,  18 ,  19 ,  20 ,  21 ,  22 ,  23 ,  24 ,  25 ,  26 ,  27 ,  28 , 29
       #shift_box = [[1 ,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,""],
      shift_box = []
      shift_box[0] = [1 ,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,""]
      #抜き取る
      userid = 1
      times = []
      user.where("id > ?", 1).each_with_index do |user,u|
        user.jobs.where(day_id: day.id).each_with_index do |job|
          unless job.time1 == nil || job.time1 == "×"
            shift_box[userid] = ["",false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,""]
            shift_box[userid][0] = user.id
            shift_box[userid][29] = job.time1
            times[userid - 1] = []
            if job.time1.match?(/F/i)
              times[userid - 1] = [9,21]
            elsif job.time1.match?(/\d/)
              times[userid - 1] = job.time1.scan(/\d+/)
              times[userid - 1] = times[userid - 1].map(&:to_i)
              if job.time1.match?(/L/i)
                times[userid - 1] << 21
              end
            else
              times[userid - 1] = [22,22]
            end
            userid += 1
          end
        end
      end

      while userid < 12
        shift_box[userid] = ["",false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,""]
        userid += 1
      end

      userid.times do
        sheet.add_row(empty_row)#, style: center_style
        row += 1
      end

      #並び替え
      swap = true
      while swap
        swap = false
        (1...times.length).each do |n|
          if times[n][0] < times[n-1][0]
            times[n], times[n-1] = times[n-1], times[n] # 要素を入れ替え
            shift_box[n+1][0], shift_box[n][0] = shift_box[n][0], shift_box[n+1][0]
            shift_box[n+1][29], shift_box[n][29] = shift_box[n][29], shift_box[n+1][29]
            swap = true
          end
        end
      end
      
      #読み取った数値からtrueを特定の場所へ格納
      times.each_with_index do |k,n|
        k.each_with_index do |i,j|
          if i == 5 || i == 30
            y = (2*k[j-1])-18 +1 # +1 IDつけたから
            shift_box[n+1][y] = false
            shift_box[n+1][y+1] = true
          elsif i == 22

          else
            y = (2*i)-18 +1 # +1 IDつけたから
            shift_box[n+1][y] = true
          end
        end
      end

      #間をtrueで埋める
      shift_box.each_with_index do |k,j|
        if j > 0
          triga = 0
          k.each_with_index do |i,n|
            if n > 0 #最初の配列は店長だからスキップ
              if triga == 0
                if i == true
                  triga = 1
                end
              else
                if i == true
                  shift_box[j][n] = false
                  break #この時点で終わり
                else
                  shift_box[j][n] = true
                end
              end
            end
          end
        end
      end
      

      shift_box.each_with_index do |k,i|
        k.each_with_index do |j,x|
          if j == true
            sheet.rows[i+2].cells[x].style = blue_style(x,workbook)
          elsif j == false
            sheet.rows[i+2].cells[x].style = white_style(x,workbook)
          elsif j.is_a?(Integer)
            sheet.rows[i+2].cells[x].value = User.find(j).name
            sheet.rows[i+2].cells[x].style = name_style
          elsif x == 29
            sheet.rows[i+2].cells[x].value = j
          else
            sheet.rows[i+2].cells[x].style = name_style
          end
        end
      end
#月曜日ここまで

#火曜日
      sheet.add_row(empty_row, style: thick_top_border_style)
      row += 1
      sheet.add_row(empty_row, style: thick_border_style)
      row += 1

      merge_ranges = [
        "C#{row}:D#{row}", "E#{row}:F#{row}", "G#{row}:H#{row}", "I#{row}:J#{row}", "K#{row}:L#{row}",
        "M#{row}:N#{row}", "O#{row}:P#{row}", "Q#{row}:R#{row}", "S#{row}:T#{row}", "U#{row}:V#{row}",
        "W#{row}:X#{row}", "Y#{row}:Z#{row}", "AA#{row}:AB#{row}"
      ]
      merge_ranges.each { |range| sheet.merge_cells(range) }
      head = ["#{day.start.month}月#{(day.start.day) + 1}日（火）", "", 10, "", 11, "", 12, "", 13, "", 14, "", 15, "", 16, "", 17, "", 18, "", 19, "", 20, "", 21, "", 22, ""]
      head.each_with_index do |value, i|
        sheet.rows[row-1].cells[i].value = value
      end
      (2..26).step(2).each { |int| sheet.rows[row-1].cells[int].type = :integer }

      #列の幅指定（最後）
      sheet.column_widths 14, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 12, 12
    end

    send_data package.to_stream.read, type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", filename: "#{day.start.month}月#{day.start.day}日～.xlsx"

  end

  private

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