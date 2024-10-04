class CreateTues < ActiveRecord::Migration[6.1]
  def change
    create_table :tues do |t|
      t.integer :day_id
      t.timestamps
    end
  end
end
