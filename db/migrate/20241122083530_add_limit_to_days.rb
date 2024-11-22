class AddLimitToDays < ActiveRecord::Migration[6.1]
  def change
    add_column :days, :limit, :boolean, default: false
  end
end
