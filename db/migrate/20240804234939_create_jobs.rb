class CreateJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :jobs do |t|

      t.integer :time
      t.integer :day
      t.integer :user_id
      t.string :remark

      t.timestamps
    end
  end
end
