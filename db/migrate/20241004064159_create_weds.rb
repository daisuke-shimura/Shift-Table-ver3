class CreateWeds < ActiveRecord::Migration[6.1]
  def change
    create_table :weds do |t|
      t.integer :day_id
      t.timestamps
    end
  end
end
