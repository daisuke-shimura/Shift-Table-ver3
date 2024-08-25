class CreateJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :jobs do |t|

      t.string :time1
      t.string :time2
      t.string :time3
      t.string :time4
      t.string :time5
      t.string :time6
      t.string :time7

      t.integer :day
      t.integer :user_id
      t.string :remark

      t.timestamps
    end
  end
end
