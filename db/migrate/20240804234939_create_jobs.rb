class CreateJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :jobs do |t|

      t.string :time1 , default: ""
      t.string :time2 , default: ""
      t.string :time3 , default: ""
      t.string :time4 , default: ""
      t.string :time5 , default: ""
      t.string :time6 , default: ""
      t.string :time7 , default: ""

      t.integer :day
      t.integer :user_id
      t.string :remark

      t.timestamps
    end
  end
end
