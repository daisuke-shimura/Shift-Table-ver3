class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :time1, default: ""
      t.string :time2, default: ""
      t.string :time3, default: ""
      t.string :time4, default: ""
      t.string :time5, default: ""
      t.string :time6, default: ""
      t.string :time7, default: ""
      t.integer :day_id
      t.timestamps
    end
  end
end
