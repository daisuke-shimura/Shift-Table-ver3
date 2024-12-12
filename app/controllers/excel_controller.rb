class ExcelController < ApplicationController
  #table作成
  def export
    @day = Day.find(params[:day_id])
    @user = User.all
    @row = 0

    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Sheet1") do |sheet|

      thick_border_style = workbook.styles.add_style(
        alignment: { horizontal: :center ,vertical: :center},
        border: { style: :medium, color: '000000', edges: [:bottom] },
        font_name: "AR丸ゴシック体M")
      thick_top_border_style = workbook.styles.add_style(
        alignment: { horizontal: :center ,vertical: :center},
        border: { style: :medium, color: '000000', edges: [:bottom, :top] },
        font_name: "AR丸ゴシック体M")

      footer_style = workbook.styles.add_style(
        alignment: { horizontal: :center ,vertical: :center},
        border: { style: :medium, color: '000000', edges: [:bottom, :top] },
        b: true,                   # 太字
        font_name: "HGP創英角ﾎﾟｯﾌﾟ体"     # フォントの種類
        )

      name_style = workbook.styles.add_style(
        alignment: { horizontal: :center ,vertical: :center},
        border: [{ style: :thin, color: '000000', edges: [:right, :bottom] },
                 { style: :medium, color: "000000", edges: [:left] }],
        font_name: "AR丸ゴシック体M"
      )
      head_style = workbook.styles.add_style(
        alignment: { horizontal: :center ,vertical: :center},
        border: [{ style: :thin, color: '000000', edges: [:left, :bottom] },
                 { style: :medium, color: "000000", edges: [:right] }],
        font_name: "AR丸ゴシック体M"
      )

      empty_row = Array.new(30, " ")

      day_week = ["#{@day.start.month}月#{@day.start.day}日（月）",
                  "#{(@day.start+1).month}月#{(@day.start+1).day}日（火）",
                  "#{(@day.start+2).month}月#{(@day.start+2).day}日（水）",
                  "#{(@day.start+3).month}月#{(@day.start+3).day}日（木）",
                  "#{(@day.start+4).month}月#{(@day.start+4).day}日（金）",
                  "#{(@day.start+5).month}月#{(@day.start+5).day}日（土）",
                  "#{(@day.start+6).month}月#{(@day.start+6).day}日（日）",]
      
      sheet.page_margins do |margins|
        margins.left = 0      # 左余白
        margins.right = 0     # 右余白
        margins.top = 0       # 上余白
        margins.bottom = 0    # 下余白
        margins.header = 0    # ヘッダー余白
        margins.footer = 0    # フッター余白
      end

  #月曜日ここから
    head_print(sheet, workbook, day_week, empty_row, 0)
    shift_print(workbook, sheet, :time1, 0)
  #月曜日ここまで

  #火曜日
    head_print(sheet, workbook, day_week, empty_row, 1)
    shift_print(workbook, sheet, :time2, 1)

  #水曜日
    head_print(sheet, workbook, day_week, empty_row, 2)
    shift_print(workbook, sheet, :time3, 2)

  #木曜日
    head_print(sheet, workbook, day_week, empty_row, 3)
    shift_print(workbook, sheet, :time4, 3)

  #金曜日
    head_print(sheet, workbook, day_week, empty_row, 4)
    shift_print(workbook, sheet, :time5, 4)

  #土曜日
    head_print(sheet, workbook, day_week, empty_row, 5)
    shift_print(workbook, sheet, :time6, 5)

  #日曜日
    head_print(sheet, workbook, day_week, empty_row, 6)
    shift_print(workbook, sheet, :time7, 6)
    
    sheet.add_row(empty_row, style: thick_top_border_style, height: 25)
    @row += 1
    sheet.add_row(empty_row, style: footer_style, height: 25)
    @row += 1

    sheet.rows[@row-1].cells[0].value = "#{(@day.start).year} シフト表"

    sheet.merge_cells("A#{@row}:AC#{@row}")

      #列の幅指定（最後）
      sheet.column_widths 13.5, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 2.4, 11.5, 12
    end

    send_data package.to_stream.read, type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", filename: "#{@day.start.month}月#{@day.start.day}日～.xlsx"

  end

  private

    def blue_style(x,workbook)
      n2_border = workbook.styles.add_style(
        alignment: { horizontal: :center ,vertical: :center},
        bg_color: "4BACC6", 
        border: [{ style: :medium, color: "000000", edges: [:right] },
                { style: :thin, color: "000000", edges: [:bottom] }],
        font_name: "AR丸ゴシック体M"
      )
      n1_border = workbook.styles.add_style(
        alignment: { horizontal: :center ,vertical: :center},
        bg_color: "4BACC6",
        border: { style: :thin, color: "000000", edges: [:right, :bottom] },
        font_name: "AR丸ゴシック体M"
      )
      if x % 2 == 0
        n2_border
      else
        n1_border
      end
    end

    def white_style(x,workbook)
      n2_border = workbook.styles.add_style(
        alignment: { horizontal: :center ,vertical: :center},
        border: [{ style: :medium, color: "000000", edges: [:right] },
                { style: :thin, color: "000000", edges: [:bottom] }],
        font_name: "AR丸ゴシック体M"
      )
      n1_border = workbook.styles.add_style(
        alignment: { horizontal: :center ,vertical: :center},
        border: { style: :thin, color: "000000", edges: [:right, :bottom] },
        font_name: "AR丸ゴシック体M"
      )
      if x % 2 == 0
        n2_border
      else
        n1_border
      end
    end


    def head_print(sheet, workbook, day_week, empty_row, week_n)

      thick_border_style = workbook.styles.add_style(
        alignment: { horizontal: :center ,vertical: :center},
        border: { style: :medium, color: '000000', edges: [:bottom] },
        font_name: "AR丸ゴシック体M")

      thick_top_border_style = workbook.styles.add_style(
        alignment: { horizontal: :center ,vertical: :center},
        border: { style: :medium,color: '000000', edges: [:bottom, :top] },
        font_name: "AR丸ゴシック体M")

      top_only_border_style = workbook.styles.add_style(
        alignment: { horizontal: :center ,vertical: :center},
        border: { style: :medium,color: '000000', edges: [:top] },
        font_name: "AR丸ゴシック体M")

      blue_style = workbook.styles.add_style(
        alignment: { horizontal: :center ,vertical: :center},
        border: { style: :medium, color: '000000', edges: [:bottom] },
        fg_color: "0070C0",
        font_name: "AR丸ゴシック体M")

      red_style = workbook.styles.add_style(
        alignment: { horizontal: :center ,vertical: :center},
        border: { style: :medium, color: '000000', edges: [:bottom] },
        fg_color: "FF0000",
        font_name: "AR丸ゴシック体M")

      if week_n == 0
        sheet.add_row(empty_row, style: thick_border_style, height: 7)
        @row += 1
      elsif week_n == 4
        sheet.add_row(empty_row, style: top_only_border_style)#印刷分かれる
        @row += 1
        sheet.add_row(empty_row, style: thick_border_style, height: 20)
        @row += 1
      elsif week_n == 5 || week_n == 6
        sheet.add_row(empty_row, style: thick_top_border_style, height: 30)
        @row += 1
      else
        sheet.add_row(empty_row, style: thick_top_border_style, height: 8)
        @row += 1
      end

      sheet.add_row(empty_row, style: thick_border_style, height: 16.5)
        @row += 1

      merge_ranges = ["C#{@row}:D#{@row}", "E#{@row}:F#{@row}", "G#{@row}:H#{@row}", "I#{@row}:J#{@row}", "K#{@row}:L#{@row}",
                      "M#{@row}:N#{@row}", "O#{@row}:P#{@row}", "Q#{@row}:R#{@row}", "S#{@row}:T#{@row}", "U#{@row}:V#{@row}",
                      "W#{@row}:X#{@row}", "Y#{@row}:Z#{@row}", "AA#{@row}:AB#{@row}"]

      merge_ranges.each { |range| sheet.merge_cells(range) }
      head = ["#{day_week[week_n]}", "", 10, "", 11, "", 12, "", 13, "", 14, "", 15, "", 16, "", 17, "", 18, "", 19, "", 20, "", 21, "", 22, ""]
      head.each_with_index do |value, i|
        sheet.rows[@row-1].cells[i].value = value
      end

      if week_n == 0
        if @day.mon_by?(@day.id)
          sheet.rows[@row-1].cells[0].style = red_style
        end
      elsif week_n == 1
        if @day.tue_by?(@day.id)
          sheet.rows[@row-1].cells[0].style = red_style
        end
      elsif week_n == 2
        if @day.wed_by?(@day.id)
          sheet.rows[@row-1].cells[0].style = red_style
        end
      elsif week_n == 3
        if @day.thu_by?(@day.id)
          sheet.rows[@row-1].cells[0].style = red_style
        end
      elsif week_n == 4
        if @day.fri_by?(@day.id)
          sheet.rows[@row-1].cells[0].style = red_style
        end
      elsif week_n == 5
        if @day.sat_by?(@day.id)
          sheet.rows[@row-1].cells[0].style = red_style
        else
          sheet.rows[@row-1].cells[0].style = blue_style
        end
      elsif week_n == 6
        sheet.rows[@row-1].cells[0].style = red_style
      end

      (2..26).step(2).each { |int| sheet.rows[@row-1].cells[int].type = :integer }

    end


    def shift_print(workbook, sheet, time_column, week_n)
      name_style = workbook.styles.add_style(
        alignment: { horizontal: :center ,vertical: :center},
        border: [{ style: :thin, color: '000000', edges: [:right, :bottom] },
                 { style: :medium, color: "000000", edges: [:left] }],
        font_name: "AR丸ゴシック体M"
      )
      manager_style = workbook.styles.add_style(
        alignment: { horizontal: :center ,vertical: :center},
        border: [{ style: :thin, color: '000000', edges: [:right, :bottom] },
                 { style: :medium, color: "000000", edges: [:left] }],
        fg_color: "00B050",
        b: true,
        font_name: "AR丸ゴシック体M"
      )
      empty_row = Array.new(30, " ")
      shift_box = []
      shift_box[0] = [1 ,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,""]
      #抜き取る
      userid = 1
      times = []
      @user.where("id > ?", 1).each_with_index do |user,u|
        user.jobs.where(day_id: @day.id).each_with_index do |job|
          time_n = job.public_send(time_column)
          unless time_n.blank? || time_n == "×"
            shift_box[userid] = ["",false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,""]
            shift_box[userid][0] = user.id
            shift_box[userid][29] = time_n
            times[userid - 1] = []
            if time_n.match?(/F/i)
              times[userid - 1] = [9,21]
            elsif time_n.match?(/\d/)
              times[userid - 1] = time_n.scan(/\d+/)
              times[userid - 1] = times[userid - 1].map(&:to_i)
              if time_n.match?(/L/i)
                times[userid - 1] << 21
              end
            else
              times[userid - 1] = [22,22]
            end
            userid += 1
          end
        end
      end

      if week_n == 0
        while userid < 11
          shift_box[userid] = ["",false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,""]
          userid += 1
        end
      elsif week_n >= 4
        while userid < 12
          shift_box[userid] = ["",false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,""]
          userid += 1
        end
      else
        while userid < 10
          shift_box[userid] = ["",false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,""]
          userid += 1
        end
      end

      userid.times do
        sheet.add_row(empty_row, height: 16.5)#, style: name_style
        @row += 1
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
          elsif 9 <= i && i <= 21
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
                  triga = 0
                  #break #この時点で終わり
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
              sheet.rows[@row - userid + i].cells[x].style = blue_style(x,workbook)
            elsif j == false
              sheet.rows[@row - userid + i].cells[x].style = white_style(x,workbook)
            elsif j.is_a?(Integer)
              sheet.rows[@row - userid + i].cells[x].value = User.find(j).name
              if j == 1
                sheet.rows[@row - userid + i].cells[x].style = manager_style
              else
                sheet.rows[@row - userid + i].cells[x].style = name_style
              end
            elsif x == 29
              sheet.rows[@row - userid + i].cells[x].value = j
            else
              sheet.rows[@row - userid + i].cells[x].style = name_style
            end
        end
      end

    end

end