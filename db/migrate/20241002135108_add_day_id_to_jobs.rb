class AddDayIdToJobs < ActiveRecord::Migration[6.1]
  def change
    add_column :jobs, :day_id, :integer
  end
end
