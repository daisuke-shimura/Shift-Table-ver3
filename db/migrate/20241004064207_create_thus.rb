class CreateThus < ActiveRecord::Migration[6.1]
  def change
    create_table :thus do |t|
      t.integer :day_id
      t.timestamps
    end
  end
end
