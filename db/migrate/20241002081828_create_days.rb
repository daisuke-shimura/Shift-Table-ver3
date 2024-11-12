class CreateDays < ActiveRecord::Migration[6.1]
  def change
    create_table :days do |t|
      t.date :start, null: false
      t.date :finish, null: false
      t.timestamps
    end
  end
end
