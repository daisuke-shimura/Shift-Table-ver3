class CreateMons < ActiveRecord::Migration[6.1]
  def change
    create_table :mons do |t|
      t.integer :day_id
      t.timestamps
    end
  end
end
